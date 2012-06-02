/** 
 * gshpvoronoi -- Create Voronoi polygons from point shapefiles
 * Copyright (C) 2006 DC Water and Environment http://www.dorsch.de
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <gtk/gtk.h>

#include "interface.h"
#include "support.h"

#ifdef G_OS_WIN32
gchar *package_prefix = PACKAGE_PREFIX;
gchar *package_data_dir = PACKAGE_DATA_DIR;
gchar *package_locale_dir = PACKAGE_LOCALE_DIR;
#endif

int
main (int argc, char *argv[])
{
  GtkWidget *window_gshpvoronoi;

  gchar *pixmap_dir;
#ifdef G_OS_WIN32
  package_prefix = g_win32_get_package_installation_directory (NULL, NULL);
  package_data_dir = g_build_filename (package_prefix, "share", NULL);
  package_locale_dir = g_build_filename (package_prefix, "share", "locale", NULL);
#endif

#ifdef ENABLE_NLS
  bindtextdomain (GETTEXT_PACKAGE, package_locale_dir);
  bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
  textdomain (GETTEXT_PACKAGE);
#endif

  gtk_set_locale ();
  gtk_init (&argc, &argv);

  pixmap_dir = g_build_filename (package_data_dir, PACKAGE, "pixmaps", NULL);
  add_pixmap_directory (pixmap_dir);
  g_free (pixmap_dir);


  /*
   * The following code was added by Glade to create one of each component
   * (except popup menus), just so that you see something after building
   * the project. Delete any components that you don't want shown initially.
   */
  window_gshpvoronoi = create_window_gshpvoronoi ();
  gtk_widget_show (window_gshpvoronoi);
  g_signal_connect ((gpointer) window_gshpvoronoi, "destroy", G_CALLBACK(gtk_main_quit),
                    NULL);
  
  
  gtk_main ();

#ifdef G_OS_WIN32
  g_free (package_prefix);
  g_free (package_data_dir);
  g_free (package_locale_dir);
#endif

  return 0;
}
#ifdef _MSC_VER
#include <windows.h>

int WINAPI WinMain(HINSTANCE hInstance,
                   HINSTANCE hPrevInstance,
                   LPSTR lpCmdLine,
                   int nCmdShow)
{
  return main (__argc, __argv);
}
#endif

