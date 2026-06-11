package com.nooralmasoomeen.noor_al_masoomeen

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

class NoorWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val prefs = context.getSharedPreferences(
            "home_widget_plugin",
            Context.MODE_PRIVATE
        )
        val masoom = prefs.getString("widget_masoom", null)
        val text = prefs.getString("widget_text", null)

        val views = RemoteViews(context.packageName, R.layout.noor_widget_layout)
        if (masoom != null) {
            views.setTextViewText(R.id.widget_masoom, masoom)
        }
        if (text != null) {
            views.setTextViewText(R.id.widget_text, text)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
