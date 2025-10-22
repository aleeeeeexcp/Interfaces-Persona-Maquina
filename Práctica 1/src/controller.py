import gi
import gettext
import threading

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GLib, GObject

from view import View
from model import Model

_ = gettext.gettext
N_ = gettext.ngettext


class Controller:
    def __init__(self):
        self.view = View()
        self.model = Model()
        self.view.on_search_changed(self.search_clicked)

    def start(self):
        self.view.show_all()
        self.view.start()

    def search_clicked(self, widget):
        text = self.view.searchentry.get_text()
        api_thead = threading.Thread(target=self.on_search_changed, args=(text,))
        api_thead.start()

    def on_search_changed(self, text):
        if not self.view.searchentry.get_text():
            self.view.cocktail_grid.set_visible(False)
            self.view.cocktail_label.set_visible(False)
            self.view.description_label.set_visible(False)
            self.view.glass_label.set_visible(False)
            self.view.image.set_visible(False)
            self.view.new_error(_("Not valid"))
        else:
            results = self.model.search_cocktails(text)
            if results is not None and 'drinks' in results:
                drinks = results['drinks']
                if drinks is not None and len(drinks) > 0:
                    self.view.cocktail_grid.set_visible(False)
                    drink = results['drinks'][0]
                    self.view.cocktail_label.set_markup(_(f'<span size="large"><b>{drink["strDrink"]}</b></span>'))
                    self.view.description_label.set_markup(
                        _(f'<span size="large"><i>{drink["strInstructions"]}</i></span>'))
                    self.view.glass_label.set_markup(_(f'<span size="large">{drink["strGlass"]}</span>'))
                    image_url = drink["strDrinkThumb"]
                    filename = "cocktail.jpg"
                    if image_url:
                        download_thread = threading.Thread(target=self.model.download_image, args=(image_url, filename))
                        download_thread.start()
                        download_thread.join()
                    self.view.update_image(filename)
                else:
                    self.view.cocktail_grid.set_visible(False)
                    self.view.cocktail_label.set_visible(False)
                    self.view.description_label.set_visible(False)
                    self.view.glass_label.set_visible(False)
                    self.view.image.set_visible(False)
                    self.view.new_error(_("ERROR: The cocktail searched does not exist"))