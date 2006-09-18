#include <gtk/gtk.h>


void
on_new1_activate                       (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_open1_activate                      (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_save1_activate                      (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_save_as1_activate                   (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_cut1_activate                       (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_copy1_activate                      (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_paste1_activate                     (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_delete1_activate                    (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_about_giconv_activate               (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_about_giconv_activate               (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_button_ok_clicked                   (GtkButton       *button,
                                        gpointer         user_data);

void
on_button_cancel_clicked               (GtkButton       *button,
                                        gpointer         user_data);

void
on_button_ok_clicked                   (GtkButton       *button,
                                        gpointer         user_data);

void
on_about_gshpvoronoi_activate          (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_help_gshpvoronoi_activate           (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

gchar *
gshpvoronoi_get_data_directory         (const gchar* subdir);

void
message_warning                        (const char *format, ...);

void
on_filechooserbutton_input_realize     (GtkWidget       *widget,
                                        gpointer         user_data);
