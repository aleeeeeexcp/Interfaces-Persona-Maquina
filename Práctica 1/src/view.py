import gettext
import gi
import os

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GdkPixbuf, GObject
from model import Model

_ = gettext.gettext
N_ = gettext.ngettext

dir = os.path.dirname(os.path.abspath(__file__))

class View:
    def start(self):
        Gtk.main()

    def quit(self, widget=None, event=None):
        Gtk.main_quit()

    def __init__(self):
        self.model = Model()
        self.window = Gtk.Window(title="IPM")
        self.window.set_default_size(1500, 900)
        self.window.connect("destroy", quit)

        self.cocktail_grid = None

        self.boxPrincipal = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        self.window.add(self.boxPrincipal)

        self.boxMenuLateralIzda = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.boxPrincipal.pack_start(self.boxMenuLateralIzda, expand=False, fill=False, padding=10)
        self.boxMenuLateralIzda.set_size_request(300, -1)

        self.boxMenuPrincipalDrcha = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.boxPrincipal.pack_start(self.boxMenuPrincipalDrcha, expand=True, fill=True, padding=10)

        markup = '<span size="xx-large" font_weight="bold" font_family="Arial">TheCocktail</span>'
        self.LabelTitulo = Gtk.Label()
        self.LabelTitulo.set_markup(markup)
        self.boxMenuPrincipalDrcha.pack_start(self.LabelTitulo, expand=False, fill=False, padding=50)

        self.boxBarraBuscadora = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        self.searchLabel = Gtk.Label()
        self.boxBarraBuscadora.pack_start(self.searchLabel, expand=False, fill=False, padding=10)
        self.searchentry = Gtk.SearchEntry()
        self.boxBarraBuscadora.pack_start(self.searchentry, expand=False, fill=False, padding=10)

        self.boxMenuLateralIzda.pack_start(self.boxBarraBuscadora, expand=False, fill=False, padding=10)

        self.menu_grid = Gtk.Grid()
        self.menu_grid.set_column_spacing(10)
        self.boxMenuPrincipalDrcha.pack_start(self.menu_grid, expand=False, fill=False, padding=10)

        result_label = Gtk.Label()
        result_label.set_markup('<span size="large"><b> </b></span>')
        self.menu_grid.attach(result_label, 0, 0, 1, 1)

        self.image = Gtk.Image()
        self.menu_grid.attach(self.image, 1, 0, 1, 3)

        self.cocktail_label = Gtk.Label()
        self.cocktail_label.set_markup('<span size="large"></span>')
        self.menu_grid.attach(self.cocktail_label, 2, 0, 1, 1)

        self.description_label = Gtk.Label()
        self.description_label.set_markup('<span size="large"></span>')
        self.description_label.set_line_wrap(True)  # Configura el wrap en True
        self.menu_grid.attach(self.description_label, 2, 1, 1, 1)

        self.glass_label = Gtk.Label()
        self.glass_label.set_markup('<span size="large"></span>')
        self.menu_grid.attach(self.glass_label, 2, 2, 1, 1)

        self.cocktail_grid = Gtk.Grid()
        self.cocktail_grid.set_column_spacing(50)
        self.cocktail_grid.set_row_spacing(50)
        self.boxMenuPrincipalDrcha.pack_start(self.cocktail_grid, expand=False, fill=False, padding=10)

        self.set_images()

    def on_search_changed(self, searchentry):
        self.searchentry.connect('activate', searchentry)

    def set_images(self):
        image_paths = [
            os.path.join(dir, "cocktail_A Night In Old Mandalay.jpg"),
            os.path.join(dir, "cocktail_Brandon and Will's Coke Float.jpg"),
            os.path.join(dir, "cocktail_Casino Royale.jpg"),
            os.path.join(dir, "cocktail_Duchamp's Punch.jpg"),
            os.path.join(dir, "cocktail_Malibu Twister.jpg"),
            os.path.join(dir, "cocktail_Mojito.jpg"),
            os.path.join(dir, "cocktail_Singapore Sling.jpg"),
            os.path.join(dir, "cocktail_Vodka Tonic.jpg"),
        ]
        row, col = 0, 0

        for image_path in image_paths:
            image = Gtk.Image()
            pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_size(image_path, 200, 200)
            image.set_from_pixbuf(pixbuf)
            image.set_hexpand(True)
            self.cocktail_grid.attach(image, col, row, 1, 1)
            col += 1
            if col == 4:
                col = 0
                row += 1


    def new_error(self, text):
        if hasattr(self, "infobar"):
            self.infobar.hide()
            del self.infobar
        self.cocktail_grid.set_visible(False)
        self.infobar = Gtk.InfoBar()
        self.infobar.connect("response", self.on_infobar_response)
        self.infobar.set_show_close_button(True)
        self.infobar.set_message_type(Gtk.MessageType.ERROR)
        self.infobar.show()

        self.boxMenuPrincipalDrcha.pack_start(self.infobar, expand=False, fill=False, padding=10)
        texto = Gtk.Label(text)
        texto.show()
        content = self.infobar.get_content_area()
        content.add(texto)
        self.infobar.set_message_type(Gtk.MessageType.ERROR)

    def update_image(self, filename):
        pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_size(filename, 500, 500)
        self.image.set_from_pixbuf(pixbuf)

    def on_infobar_response(self, infobar, respose_id):
        self.cocktail_grid.set_visible(True)
        self.infobar.hide()

    def show_all(self):
        self.window.show_all()
