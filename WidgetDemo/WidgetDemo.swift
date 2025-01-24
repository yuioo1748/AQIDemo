//
//  WidgetDemo.swift
//  WidgetDemo
//
//  Created by AndyHsieh on 2025/1/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for minuteOffset in 0..<60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct WidgetDemoEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) { // 調整對齊方式和內部間距
            HStack {
                Text("Time:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(entry.date, style: .time) // 動態顯示時間
                    .font(.title)
                    .bold()
            }

            HStack {
                Text("Emoji:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(entry.emoji)
                    .font(.largeTitle)
            }

            Spacer() // 推動內容靠上，使下方空間更有彈性
        }
        .padding() // 增加內邊距
        .background(
            RoundedRectangle(cornerRadius: 15) // 添加圓角背景
                .fill(Color.blue.opacity(0.2)) // 使用透明藍色背景
        )
        .padding([.horizontal], 10) // 調整外邊距
    }
}


struct WidgetDemo: Widget {
    let kind: String = "WidgetDemo"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetDemoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetDemoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
