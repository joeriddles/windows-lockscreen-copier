import logging
import os
import os.path
import shutil
import sys

import click
from PIL import Image

HOME_DIR = os.path.normpath(os.path.expanduser("~\\Pictures\\Lockscreens"))
SOURCE_DIR = os.path.normcase(os.path.expanduser("~\\AppData\\Local\\Packages\\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\\LocalState\\Assets\\"))


logger = logging.getLogger(__name__)
formatter = logging.Formatter("%(asctime)s %(levelname)s: %(message)s")
stream_handler = logging.StreamHandler(sys.stdout)
stream_handler.setFormatter(formatter)
file_handler = logging.FileHandler(os.path.join(HOME_DIR, ".windows-lockscreen-copier.txt"))
file_handler.setFormatter(formatter)
logger.setLevel(logging.INFO)
logger.addHandler(stream_handler)
logger.addHandler(file_handler)


@click.command()
@click.option("--destination", default=HOME_DIR, help="The folder to copy the images to.")
@click.option("--source", default=SOURCE_DIR, help="The folder to find the lockscreen images in.")
@click.option("--split", default=True, help="If True, split desktop and mobile images into separate folders.")
def copy_lockscreen_images(destination: str, source: str, split: bool):
    if not os.path.exists(destination):
        raise ValueError(f"Destination does not exist: {destination}")
    if not os.path.exists(source):
        raise ValueError(f"Source does not exist: {source}")
    
    copied_count = 0
    desktop_count = 0
    mobile_count = 0
    for image_filename in os.listdir(source):
        image_filepath = os.path.join(source, image_filename)
        image = Image.open(image_filepath)
        width, height = image.size
        
        is_desktop = width > height
        is_mobile = width < height
        if is_desktop:
            new_filename = f"desktop_{image_filename}.jpg"
            desktop_count += 1
        elif is_mobile:
            new_filename = f"mobile_{image_filename}.jpg"
            mobile_count += 1
        else:
            logger.debug(f"Non-image file found: {image_filename}")
            continue

        if split and is_desktop:
            destination_path = os.path.join(destination, "desktop", new_filename) 
        elif split and is_mobile:
            destination_path = os.path.join(destination, "mobile", new_filename)
        else:
            destination_path = os.path.join(destination, new_filename)

        shutil.copy2(image_filepath, destination_path)  # copy2 preserves metadata
        copied_count += 1

    logger.info(
        f"Copied {copied_count} files to {destination}\n"
        f"  - {desktop_count} desktop images\n"
        f"  - {mobile_count} mobile images"
    )


if __name__ == "__main__":
    copy_lockscreen_images()
