package com.nooralmasoomeen.noor_al_masoomeen

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class NoorWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val prefs = context.getSharedPreferences(
                "HomeWidgetPreferences",
                Context.MODE_PRIVATE
            )
            val masoom = prefs.getString("widget_masoom", null)
            val text = prefs.getString("widget_text", null)
            val category = prefs.getString("widget_category", null)

            val views = RemoteViews(context.packageName, R.layout.noor_widget_layout)

            if (category != null) {
                views.setTextViewText(R.id.widget_category, category)
            }
            if (masoom != null) {
                views.setTextViewText(R.id.widget_masoom, masoom)
            }
            if (text != null) {
                views.setTextViewText(R.id.widget_text, text)
            }

            val intent = Intent(context, MainActivity::class.java)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
