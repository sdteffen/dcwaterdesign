#include <gtk/gtk.h>


void
on_about_giconv_activate               (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_button_ok_clicked                   (GtkButton       *button,
                                        gpointer         user_data);

void
on_filechooserbutton_input1_realize    (GtkWidget       *widget,
                                        gpointer         user_data);

void
on_filechooserbutton_input2_realize    (GtkWidget       *widget,
                                        gpointer         user_data);
