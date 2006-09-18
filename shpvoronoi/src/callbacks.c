/** 
 * gshpvoronoi -- Create Voronoi polygons from point shapefiles.
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

#include "callbacks.h"
#include "interface.h"
#include "support.h"

#ifdef G_OS_WIN32
#include <windows.h>
#include <direct.h>
#endif

void
on_new1_activate                       (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{

}


void
on_open1_activate                      (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{

}


void
on_save1_activate                      (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{

}


void
on_save_as1_activate                   (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{

}


void
on_cut1_activate                       (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{

}


void
on_copy1_activate                      (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{

}


void
on_paste1_activate                     (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{

}


void
on_delete1_activate                    (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{

}


void
on_about_gshpvoronoi_activate               (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
  GtkWidget *aboutdialog_gshpvoronoi;

  aboutdialog_gshpvoronoi = create_aboutdialog_gshpvoronoi ();

  gtk_widget_show (aboutdialog_gshpvoronoi);
  g_signal_connect ((gpointer) aboutdialog_gshpvoronoi, "destroy", G_CALLBACK(gtk_main_quit),
                    NULL);
}

void
on_button_ok_clicked                   (GtkButton       *button,
                                        gpointer         user_data)
{
        GtkWidget *filechooserbutton_input = NULL;
        gchar *filename_input = NULL;
        GtkWidget *filechooserwidget_output = NULL;
        gchar *filename_output = NULL;		
        gchar *cmd;
        gchar *sout;
        gchar *serror;
 	gint pstat;
 	GPid pid;
 	GIOChannel *channel;
 	GString *str;
 	GIOStatus status;
	gchar **args;
        GError  *error;
        gint exit_status;
        GtkMessageDialog *dialog;
        GtkStatusbar *statusbar;
        FILE *fh;
        GIOChannel *iochannel;
        gsize length;
        gint i;
        gint context_id;

	statusbar = lookup_widget(GTK_WIDGET(button), "statusbar_gshpvoronoi");
        context_id = gtk_statusbar_get_context_id(
                          GTK_STATUSBAR (statusbar), "gshpvoronoi");

	filechooserbutton_input = NULL;
	filechooserbutton_input = lookup_widget(GTK_WIDGET(button), "filechooserbutton_input");
	filename_input = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(filechooserbutton_input));
	filechooserwidget_output = NULL;
	filechooserwidget_output = lookup_widget(GTK_WIDGET(button), "filechooserwidget_output");
	filename_output = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(filechooserwidget_output));
	
	if((NULL == filename_input)||(NULL == filename_output)) {
             /**
              * \todo Better error handling.
              */
              g_free(filename_input);
              g_free(filename_output);
              return;
        }
	
        /**
         * \todo g_free()
         */
        cmd = g_strdup_printf ("'shpvoronoi.exe' '%s' '%s'", filename_input, filename_output);
        g_shell_parse_argv(cmd, NULL, &args, NULL);
        /**
         * \todo Fix statusbar output.
         */
        
        gtk_statusbar_push(statusbar, context_id, cmd);
 
   	if((g_spawn_sync(NULL, args, NULL, G_SPAWN_SEARCH_PATH, NULL, NULL, &sout, &serror, &exit_status, &error))&&(0 == exit_status))
 	{                        
               sout = g_strdup_printf ("Wrote '%s'", filename_output);
               gtk_statusbar_push(statusbar, context_id, sout);
	} else {
           dialog = gtk_message_dialog_new (lookup_widget(GTK_WIDGET(button), "window_gshpvoronoi"),
                                  GTK_DIALOG_DESTROY_WITH_PARENT,
                                  GTK_MESSAGE_ERROR,
                                  GTK_BUTTONS_CLOSE,
                                  serror);
                                  gtk_dialog_run (GTK_DIALOG (dialog));
                                   gtk_widget_destroy (dialog);
       gtk_dialog_run (GTK_DIALOG (dialog));
       gtk_widget_destroy (dialog);
       dialog = gtk_message_dialog_new (lookup_widget(GTK_WIDGET(button), "window_gshpvoronoi"),
                                  GTK_DIALOG_DESTROY_WITH_PARENT,
                                  GTK_MESSAGE_ERROR,
                                  GTK_BUTTONS_CLOSE,
                                  error->message);
       gtk_dialog_run (GTK_DIALOG (dialog));
       gtk_widget_destroy (dialog);
	}
 	g_free (cmd);
 	g_free(filename_output);
 	g_free(filename_input);
}

void
on_help_gshpvoronoi_activate           (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
  char *helpdir, *helpindex = NULL, *command;
  guint bestscore = G_MAXINT;
  GDir *dp;
  const char *dentry;
  GError *error = NULL;

  helpdir = gshpvoronoi_get_data_directory("doc");
  if (!helpdir) {
    message_warning(_("Could not find help directory"));
    return;
  }

 
#ifdef G_OS_WIN32
      /* use HTML Help on win32 if available */
      helpindex = g_strconcat(helpdir, G_DIR_SEPARATOR_S, "en",
			      G_DIR_SEPARATOR_S "gshpvoronoi.chm", NULL);
      if (!g_file_test(helpindex, G_FILE_TEST_EXISTS)) {
	helpindex = g_strconcat(helpdir, G_DIR_SEPARATOR_S, dentry,
			      G_DIR_SEPARATOR_S "index.html", NULL);
      }
#else
      helpindex = g_strconcat(helpdir, G_DIR_SEPARATOR_S, dentry,
			      G_DIR_SEPARATOR_S "index.html", NULL);
#endif
 
  g_free(helpdir);
  if (!helpindex) {
    message_warning(_("Could not find help directory"));
    return;
  }

#ifdef G_OS_WIN32
# define SW_SHOWNORMAL 1
  ShellExecuteA (0, "open", helpindex, NULL, helpdir, SW_SHOWNORMAL);
#else
  command = getenv("BROWSER");
  command = g_strdup_printf("%s 'file://%s' &", command ? command : "gnome-open", helpindex);
  system(command);
  g_free(command);
#endif
  g_free(helpindex);
}

/** Get the name of a subdirectory of our data directory.
 *  This function does not create the subdirectory, just make the correct name.
 * @param subdir The name of the directory desired.
 * @returns The full path to the directory.  This string should be freed
 *          after use.
 */
gchar *
gshpvoronoi_get_data_directory(const gchar* subdir)
{
#ifdef G_OS_WIN32
  /*
   * Calculate from executable path
   */
  gchar sLoc [256];
  HINSTANCE hInst = GetModuleHandle(NULL);

  if (0 != GetModuleFileName(hInst, sLoc, MAX_PATH))
    {
	/* strip the name */
      if (strrchr(sLoc, G_DIR_SEPARATOR))
        strrchr(sLoc, G_DIR_SEPARATOR)[0] = 0;
      /* and one dir (bin) */
      if (strrchr(sLoc, G_DIR_SEPARATOR))
        strrchr(sLoc, G_DIR_SEPARATOR)[1] = 0;
    }
  return g_strconcat (sLoc , subdir, NULL); 

#else
  /**
   * TODO: Real implementation
   */
  return g_strconcat (".", subdir, NULL);
  
#endif
}

void
message_warning(const char *format, ...) {
  va_list args;
  GtkMessageDialog *dialog;
  dialog = gtk_message_dialog_new (NULL,
                                  GTK_DIALOG_DESTROY_WITH_PARENT,
                                  GTK_MESSAGE_WARNING,
                                  GTK_BUTTONS_CLOSE,
                                  g_sprintf(format, &args));
       gtk_dialog_run (GTK_DIALOG (dialog));
       gtk_widget_destroy (dialog);
}

void
on_filechooserbutton_input_realize     (GtkWidget       *widget,
                                        gpointer         user_data)
{
GtkFileFilter *filter = NULL;

	filter = gtk_file_filter_new();
	gtk_file_filter_set_name(filter, "*.shp");
	gtk_file_filter_add_pattern(filter, "*.shp");
	gtk_file_chooser_add_filter(GTK_FILE_CHOOSER(widget), filter); 
}

