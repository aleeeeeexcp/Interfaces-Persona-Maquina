# Diseño software

<!-- Notas para el desarrollo de este documento
En este fichero debeis documentar el diseño software de la práctica.

warning: El diseño en un elemento "vivo". No olvideis actualizarlo a medida que cambia durante la realización de la práctica.

:warning: Recordad que el diseño debe separar _vista_ y _estado/modelo_.
	 
El lenguaje de modelado es UML y debeis usar Mermaid para incluir los diagramas dentro de este documento.
-->

```mermaid
classDiagram
  class View {
    +__init(controller: Controller)
    +run()
    +display_random_cocktails(num_cocktails: int)
    +display_cocktail(grid: Grid, row: int, col: int, cocktail: dict)
    +search_clicked(widget: Widget)
    +new_error(text: str)
    +on_infobar_response()
    +fetch_and_update_data(cocktail_name: str)
    +download_image(image_url: str, filename: str)
    +update_image(filename: str)
  }

  class Model {
    +search_cocktail(cocktail_name: str)
    +get_random_cocktails(num_cocktails: int)
  }

  class Controller {
    +__init()
    +run()
    +get_random_cocktails(num_cocktails: int)
  }

  View --> Controller
  Controller --> Model
