import json
from zipfile import ZipFile
from urllib.request import urlretrieve


class DataSourceHandler:

    ZIP_DOWNLOAD_LINK = "http://ergast.com/downloads/f1db_csv.zip"
    ZIP_LOCAL_PATH = "all_data.zip"
    ZIP_EXTRACT_PATH = "csvs"

    def __init__(self, zip_download_link=None, zip_local_path=None, zip_extract_path=None) -> None:
        if zip_download_link is None:
            zip_download_link = DataSourceHandler.ZIP_DOWNLOAD_LINK
        self.zip_download_link = zip_download_link
        if zip_local_path is None:
            zip_local_path = DataSourceHandler.ZIP_LOCAL_PATH
        self.zip_local_path = zip_local_path
        if zip_extract_path is None:
            zip_extract_path = DataSourceHandler.ZIP_EXTRACT_PATH
        self.zip_extract_path = zip_extract_path

    def update_all_from_zip(self):
        urlretrieve(self.zip_download_link, self.zip_local_path)
        with ZipFile(self.zip_local_path, 'r') as zip_ref:
            zip_ref.extractall(self.zip_extract_path)


if __name__=="__main__":
    DataSourceHandler().update_all_from_zip()