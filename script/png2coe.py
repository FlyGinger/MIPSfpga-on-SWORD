import cv2
import os


def img2coe():
    while True:
        path = input("Image path: ")
        if not os.path.exists(path):
            print("Invalid image path!")
            continue

        img = cv2.imread(path)
        if img is None:
            print("Unsupported image format or invalid path with Chinese characters!")
            continue

        coe = open(path + '.coe', 'w', encoding='utf-8')
        if coe is None:
            print("Cannot create .coe file!")
            continue

        coe.write('memory_initialization_radix=16;\n')
        coe.write('memory_initialization_vector=\n')
        size = img.shape
        for i in range(0, size[0]):
            for j in range(0, size[1]):
                r = img[i][j][2] // 16
                g = img[i][j][1] // 16
                b = img[i][j][0] // 16
                rgb = (r << 8) + (g << 4) + b
                if j == size[1] - 1:
                    coe.write("%03x" % rgb)
                else:
                    coe.write("%03x," % rgb)
            if i == size[0] - 1:
                coe.write(";\n")
            else:
                coe.write("\n")
        coe.close()
        print("Done!\n\n")


if __name__ == '__main__':
    img2coe()
