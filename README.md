import time
from luma.core.interface.serial import spi
from luma.lcd.device import st7789
from PIL import Image, ImageDraw

def main():
    print("Initialiseren van schermen met onafhankelijke RST-pinnen...")

    # --- SCHERM 1 (SPI0) ---
    serial_1 = spi(
        port=0,                 
        device=0,               
        gpio_DC=25,             # GPIO 25 (Pin 22)
        gpio_RST=24,            # GPIO 24 (Pin 18)
        bus_speed_hz=40000000
    )
    device_1 = st7789(serial_1, width=240, height=320, rotate=1)

    # --- SCHERM 2 (SPI1) ---
    serial_2 = spi(
        port=1,                 
        device=0,               
        gpio_DC=23,             # GPIO 23 (Pin 16)
        gpio_RST=22,            # GPIO 22 (Pin 15) <- NU VOLLEDIG EIGEN PIN
        bus_speed_hz=40000000
    )
    device_2 = st7789(serial_2, width=240, height=320, rotate=1)

    # --- TEST TEKENEN ---
    # Scherm 1
    img1 = Image.new("RGB", (device_1.width, device_1.height), "blue")
    draw1 = ImageDraw.Draw(img1)
    draw1.text((20, 40), "Scherm 1", fill="white")
    draw1.text((20, 70), "RST: GPIO 24", fill="yellow")
    device_1.display(img1)

    # Scherm 2
    img2 = Image.new("RGB", (device_2.width, device_2.height), "red")
    draw2 = ImageDraw.Draw(img2)
    draw2.text((20, 40), "Scherm 2", fill="white")
    draw2.text((20, 70), "RST: GPIO 22", fill="green")
    device_2.display(img2)

    print("Beide schermen zijn nu volledig onafhankelijk opgestart!")
    
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Stoppen...")

if __name__ == "__main__":
    main()
