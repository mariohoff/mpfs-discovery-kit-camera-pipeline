#include <fcntl.h>
#include <netinet/in.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <time.h>
#include <unistd.h>
#include <poll.h>
#include <errno.h>

#define DEST_ADDR (0xc8000000 >> 6)

#define SYSFS_PATH_LEN 128
#define ID_STR_LEN 32
#define UIO_DEVICE_PATH_LEN 32
#define NUM_UIO_DEVICES 32
#define UIO_DMA_DEVNAME "vdma-controller@60020000"

#define REG_CTRL 0x04
#define REG_INT_GLOBAL 0x08
#define REG_INT_FRAME 0x10
#define REG_STAT 0x0C
#define REG_ADDR 0x1C
#define REG_SIZE_RD 0x24

static char uio_id_str_dma[] = UIO_DMA_DEVNAME;
static char sysfs_template[] = "/sys/class/uio/uio%d/%s";

static uint32_t get_memory_size(char* sysfs_path, char* uio_device) {
    FILE* fp;
    uint32_t sz;
    fp = fopen(sysfs_path, "r");
    if (!fp) {
        fprintf(stderr, "unable to determine size for %s\n", uio_device);
        exit(1);
    }
    fscanf(fp, "0x%016X", &sz);
    fclose(fp);
    return sz;
}

static int get_uio_device(char* id) {
    FILE* fp;
    int i;
    size_t len;
    char file_id[ID_STR_LEN];
    char sysfs_path[SYSFS_PATH_LEN];

    for (i = 0; i < NUM_UIO_DEVICES; i++) {
        snprintf(sysfs_path, SYSFS_PATH_LEN, sysfs_template, i, "name");
        fp = fopen(sysfs_path, "r");
        if (!fp)
            break;
        fscanf(fp, "%32s", file_id);
        fclose(fp);
        len = strlen(id);
        if (len > ID_STR_LEN - 1)
            len = ID_STR_LEN - 1;
        if (strncmp(file_id, id, len) == 0)
            return i;
    }
    return -1;
}

static int clear_pending_irq(int uio_fd) {
    uint32_t irq_count = 0;
    int timeout_ms = 200;
    struct pollfd pfd;
    pfd.fd = uio_fd;
    pfd.events = POLLIN;

    int ret = poll(&pfd, 1, timeout_ms);
    if (ret < 0) {
        fprintf(stderr, "poll() failed: %s\n", strerror(errno));
        return -1;
    }
    if (ret == 0) {
        fprintf(stderr, "Poll timed out. No interrupt pending.\n");
        return 0;
    }

    ssize_t rd = read(uio_fd, &irq_count, sizeof(irq_count));
    if (rd < 0) {
        fprintf(stderr, "read() failed: %s\n", strerror(errno));
        return -1;
    }
    fprintf(stderr, "pending interrupt cleared. irq_count: %u\n", irq_count);

    return 0;
}

int main() {
    const int MAX_FRAMES = 1000;
    int irq_count = 0;
    long frame_num = 0;
    int idx = 0;
    int vdma_fd = -1;
    uint32_t vdma_mmap_size = 0;
    volatile uint32_t* vdma_dev;
    char uio_device[UIO_DEVICE_PATH_LEN];
    char sysfs_path[SYSFS_PATH_LEN];
    struct timespec start, current, frame_start, frame_end;

    printf("Locating DMA controller: %s\n", uio_id_str_dma);
    idx = get_uio_device(uio_id_str_dma);
    if (idx < 0) {
        fprintf(stderr, "Can't locate DMA UIO device\n");
        return -1;
    }

    snprintf(uio_device, UIO_DEVICE_PATH_LEN, "/dev/uio%d", idx);
    printf("Found DMA: %s\n", uio_device);

    vdma_fd = open(uio_device, O_RDWR);
    if (vdma_fd < 0) {
        perror("Failed to open DMA device");
        return -1;
    }
    printf("Opened DMA: %s, fd: %d\n", uio_device, vdma_fd);

    snprintf(sysfs_path, SYSFS_PATH_LEN, sysfs_template, idx, "maps/map0/size");
    vdma_mmap_size = get_memory_size(sysfs_path, uio_device);
    printf("Received DMA mem size: %u\n", vdma_mmap_size);

    vdma_dev = mmap(NULL, vdma_mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, vdma_fd, 0);
    if (vdma_dev == MAP_FAILED) {
        perror("Failed to mmap DMA");
        return -1;
    }
    printf("vdma_dev mmap addr: 0x%016lx\n", (uint64_t) vdma_dev);

    clear_pending_irq(vdma_fd);
    printf("Waiting for %d frames, vdma_fd: %d\n", MAX_FRAMES, vdma_fd);

    // clear interrupt on uio
    uint32_t enable = 1;
    write(vdma_fd, &enable, sizeof(enable));

    clock_gettime(CLOCK_MONOTONIC, &start);
    while (frame_num < MAX_FRAMES) {

        vdma_dev[REG_ADDR / 4] = DEST_ADDR;
        if (frame_num == 0) {
            printf("waiting for first interrupt\n");
        }
        clock_gettime(CLOCK_MONOTONIC, &frame_start);
        ssize_t rd = read(vdma_fd, &irq_count, sizeof(irq_count));
        if (rd < 0) {
            perror("Read failed");
            break;
        }
        clock_gettime(CLOCK_MONOTONIC, &frame_end);
        if (frame_num == 0) {
            printf("first interrupt received\n");
        }

        double frame_ms = (frame_end.tv_sec - frame_start.tv_sec) * 1000.0 + 
                          (frame_end.tv_nsec - frame_start.tv_nsec) / 1e6;
        
        if (frame_num % 30 == 0) {
            printf("Frame %ld | Time: %.2f ms | FPS: %.2f\n", 
                   frame_num, frame_ms, 1000.0 / frame_ms);
        }
        frame_num++;

        // clear interrupts
        vdma_dev[REG_STAT / 4] = 0x1f; 
        uint32_t enable = 1;
        write(vdma_fd, &enable, sizeof(enable));
    }
    clock_gettime(CLOCK_MONOTONIC, &current);
    double total_elapsed = (current.tv_sec - start.tv_sec) * 1000.0 + 
                           (current.tv_nsec - start.tv_nsec) / 1e6;

    printf("All %d interrupts received\n", irq_count);
    printf("total runtime: %.2f ms\n", total_elapsed);

    if (vdma_dev)
        munmap((void*)vdma_dev, vdma_mmap_size);
    if (vdma_fd >= 0)
        close(vdma_fd);

    return 0;
}
