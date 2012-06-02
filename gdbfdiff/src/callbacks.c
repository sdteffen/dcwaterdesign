#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <gtk/gtk.h>

#include "callbacks.h"
#include "interface.h"
#include "support.h"


void
on_about_giconv_activate               (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
  GtkWidget *aboutdialog_gdbfdiff;
  
  aboutdialog_gdbfdiff = create_aboutdialog_gdbfdiff ();
  gtk_widget_show (aboutdialog_gdbfdiff);
  g_signal_connect ((gpointer) aboutdialog_gdbfdiff, "destroy", G_CALLBACK(gtk_main_quit),
                    NULL);

}


void
on_button_ok_clicked                   (GtkButton       *button,
                                        gpointer         user_data)
{
 GtkWidget *filechooserbutton_input = NULL;
 gchar *filename_input = NULL;
 gchar *filename_output1 = NULL;	
 gchar *filename_output2 = NULL;	
 char *cmd;
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

 statusbar = lookup_widget(GTK_WIDGET(button), "statusbar_gdbfdiff");
 context_id = gtk_statusbar_get_context_id(
                          GTK_STATUSBAR (statusbar), "gdbfdiff");

 filechooserbutton_input = NULL;
 filechooserbutton_input = lookup_widget(GTK_WIDGET(button), "filechooserbutton_input1");
 filename_input = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(filechooserbutton_input));
 filename_output1 = g_strdup_printf("%s.xml", filename_input);
	
 if((NULL == filename_input)||(NULL == filename_output1)) {
 /**
  * \todo Better error handling.
  */
      g_free(filename_input);
      g_free(filename_output1);
      return;
    }
	
/**
 * \todo g_free()
 */
cmd = g_strdup_printf ("'dbf2xml.exe' '%s'", filename_input);
g_shell_parse_argv(cmd, NULL, &args, NULL);
/**
 * \todo Fix statusbar output.
 */

gtk_statusbar_push(statusbar, context_id, cmd);

if((g_spawn_sync(NULL, args, NULL, G_SPAWN_SEARCH_PATH, NULL, NULL, &sout, &serror, &exit_status, &error))&&(0 == exit_status))
{
        /**
        * \todo Error handling.
        * \todo Formatting.
        */
        fh = g_fopen(filename_output1, "wb");
        fwrite(sout, 1, strlen(sout), fh);
        fclose(fh);
} else {
   dialog = gtk_message_dialog_new (lookup_widget(GTK_WIDGET(button), "window_gdbfdiff"),
                          GTK_DIALOG_DESTROY_WITH_PARENT,
                          GTK_MESSAGE_ERROR,
                          GTK_BUTTONS_CLOSE,
                          serror);
                          gtk_dialog_run (GTK_DIALOG (dialog));
                           gtk_widget_destroy (dialog);
  gtk_dialog_run (GTK_DIALOG (dialog));
  gtk_widget_destroy (dialog);
  dialog = gtk_message_dialog_new (lookup_widget(GTK_WIDGET(button), "window_gdbfdiff"),
                          GTK_DIALOG_DESTROY_WITH_PARENT,
                          GTK_MESSAGE_ERROR,
                          GTK_BUTTONS_CLOSE,
                          error->message);
  gtk_dialog_run (GTK_DIALOG (dialog));
  gtk_widget_destroy (dialog);
}
/**
 * Second file
 */

 filechooserbutton_input = NULL;
 filechooserbutton_input = lookup_widget(GTK_WIDGET(button), "filechooserbutton_input2");
 filename_input = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(filechooserbutton_input));
 filename_output2 = g_strdup_printf("%s.xml", filename_input);
	
 if((NULL == filename_input)||(NULL == filename_output2)) {
 /**
  * \todo Better error handling.
  */
      g_free(filename_input);
      g_free(filename_output1);
      return;
    }
	
/**
 * \todo g_free()
 */
cmd = g_strdup_printf ("'dbf2xml.exe' '%s'", filename_input);
g_shell_parse_argv(cmd, NULL, &args, NULL);

gtk_statusbar_push(statusbar, context_id, cmd);

if((g_spawn_sync(NULL, args, NULL, G_SPAWN_SEARCH_PATH, NULL, NULL, &sout, &serror, &exit_status, &error))&&(0 == exit_status))
{
                        
  /**
   * \todo Error handling.
   * \todo Formatting.
   */
  fh = g_fopen(filename_output2, "wb");
  fwrite(sout, 1, strlen(sout), fh);
  fclose(fh);

/**
* \todo Statusbar feedback.
*/
  g_free(sout);
  sout = g_strdup_printf ("Wrote '%s'", filename_output2);
  gtk_statusbar_push(statusbar, context_id, sout);
} else {
   dialog = gtk_message_dialog_new (lookup_widget(GTK_WIDGET(button), "window_gdbfdiff"),
                          GTK_DIALOG_DESTROY_WITH_PARENT,
                          GTK_MESSAGE_ERROR,
                          GTK_BUTTONS_CLOSE,
                          serror);
                          gtk_dialog_run (GTK_DIALOG (dialog));
                           gtk_widget_destroy (dialog);
  gtk_dialog_run (GTK_DIALOG (dialog));
  gtk_widget_destroy (dialog);
  dialog = gtk_message_dialog_new (lookup_widget(GTK_WIDGET(button), "window_gdbfdiff"),
                          GTK_DIALOG_DESTROY_WITH_PARENT,
                          GTK_MESSAGE_ERROR,
                          GTK_BUTTONS_CLOSE,
                          error->message);
  gtk_dialog_run (GTK_DIALOG (dialog));
  gtk_widget_destroy (dialog);
}

cmd = g_strdup_printf ("'WinMerge.exe' '%s' '%s'", filename_output1, filename_output2);
g_shell_parse_argv(cmd, NULL, &args, NULL);
gtk_statusbar_push(statusbar, context_id, cmd);
g_spawn_sync(NULL, args, NULL, G_SPAWN_SEARCH_PATH, NULL, NULL, &sout, &serror, &exit_status, &error);

                       
g_free (cmd);
g_free(filename_output1);
g_free(filename_output2);
g_free(filename_input);
}


void
on_filechooserbutton_input1_realize    (GtkWidget       *widget,
                                        gpointer         user_data)
{
	GtkFileFilter *filter = NULL;

	filter = gtk_file_filter_new();
	gtk_file_filter_set_name(filter, "*.dbf");
	gtk_file_filter_add_pattern(filter, "*.dbf");
	gtk_file_chooser_add_filter(GTK_FILE_CHOOSER(widget), filter); 

}


void
on_filechooserbutton_input2_realize    (GtkWidget       *widget,
                                        gpointer         user_data)
{
	GtkFileFilter *filter = NULL;

	filter = gtk_file_filter_new();
	gtk_file_filter_set_name(filter, "*.dbf");
	gtk_file_filter_add_pattern(filter, "*.dbf");
	gtk_file_chooser_add_filter(GTK_FILE_CHOOSER(widget), filter); 

}

