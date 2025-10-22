import requests

class Model:
    def __init__(self):
        pass

    def download_image(self, image_url, filename):
        image_data = requests.get(image_url, stream=True)
        if image_data.status_code == 200:
            with open(filename, "wb") as f:
                for chunk in image_data:
                    f.write(chunk)
    @staticmethod
    def search_cocktails(cocktail):
        url = f"https://www.thecocktaildb.com/api/json/v1/1/search.php?s={cocktail}"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            return None
