//
//  WidgetDemo.swift
//  WidgetDemo
//
//  Created by AndyHsieh on 2025/1/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> AQIEntry {
        AQIEntry(date: Date(), aqiData: nil, error: .dataNotAvailable)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (AQIEntry) -> ()) {
        print("Widget getSnapshot 被呼叫")
        let data = AirQualityDataManager.shared.getLatestAQIData()
        print("Widget 讀取到的資料：", data as Any)
        let entry = AQIEntry(date: Date(), aqiData: data, error: data == nil ? .dataNotAvailable : nil)
        completion(entry)
    }
    
    //    // 動態更新週期
    //    private func getUpdateInterval(for aqi: Int) -> TimeInterval {
    //        switch aqi {
    //        case 0...50: return 30 * 60  // 良好時30分鐘更新
    //        case 51...100: return 15 * 60  // 普通時15分鐘更新
    //        default: return 10 * 60  // 不良時10分鐘更新
    //        }
    //    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<AQIEntry>) -> ()) {
        guard let data = AirQualityDataManager.shared.getLatestAQIData(),
              let aqi = Int(data.aqi) else {
            let entry = AQIEntry(date: Date(), aqiData: nil, error: .dataNotAvailable)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(10 * 60))) // 30 分鐘後再試
            completion(timeline)
            return
        }
        
        let nextUpdate = Date().addingTimeInterval(10 * 60)
        let entry = AQIEntry(date: Date(), aqiData: data, error: nil)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        WidgetCenter.shared.reloadAllTimelines() //嘗試看看能不能重新整理
        completion(timeline)
    }
}



struct WidgetDemoEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        if entry.aqiData != nil {
            refreshWidget()
        } else {
            ErrorView(error: entry.error)
        }
    }
    
    private func refreshWidget() -> AnyView {
        // 在這裡添加更新 Widget 的邏輯
        let data = AirQualityDataManager.shared.getLatestAQIData()
        
        // 根據 family 返回對應的視圖
        switch family {
        case .systemSmall:
            return AnyView(AQIContentView(aqiData: data ?? AQIData.empty))
        case .systemMedium:
            return AnyView(MediumWidgetView(aqiData: data ?? AQIData.empty))
        default:
            return AnyView(AQIContentView(aqiData: data ?? AQIData.empty))
        }
    }
}

// 新增 AQI 內容視圖
struct AQIContentView: View {
    let aqiData: AQIData
    
    private var aqiColor: Color {
        guard let aqiValue = Int(aqiData.aqi) else { return .gray }
        switch aqiValue {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        default: return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .lastTextBaseline) {
                Text(aqiData.siteName)
                    .font(.system(.headline, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                StatusBadge(status: aqiData.status, color: aqiColor)
                    .padding(.trailing, -20)
            }
            .padding(.top, -45)
            .padding(.leading, -20)
            
            HStack(alignment: .lastTextBaseline) {
                Text(aqiData.aqi)
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(aqiColor)
                
                Text("(AQI)")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, -30)
            .padding(.leading, -20)
            
            HStack(spacing: 20) {
                HStack(alignment: .lastTextBaseline) {
                    Text("PM")
                        .font(.system(size: 13, weight: .bold))
                    Text("2.5")
                        .font(.system(size: 8))
                        .padding(.leading, -8)
                    Text(aqiData.pm25)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .padding(.leading, -5)
                }
                .padding(.leading, -20)
                
                HStack(alignment: .lastTextBaseline) {
                    Text("PM")
                        .font(.system(size: 13, weight: .bold))
                    Text("10")
                        .font(.system(size: 8))
                        .padding(.leading, -8)
                    Text(aqiData.pm10)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .padding(.leading, -5)
                }
                .padding(.trailing, -20)
            }
            .padding(.bottom, -50)
        }
        .padding()
    }
}

// 錯誤視圖
struct ErrorView: View {
    let error: WidgetError?
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
            Text(error?.message ?? "發生錯誤")
                .font(.caption)
        }
        .foregroundColor(.gray)
    }
}

struct StatusBadge: View {
    let status: String
    let color: Color
    
    var body: some View {
        Text(status)
            .font(.system(.caption, design: .rounded))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .lineLimit(1) // 限制單行
            .truncationMode(.tail) // 超過就顯示...
            .background(color.opacity(0.2))
            .cornerRadius(4)
            .foregroundColor(color == .yellow ? .brown : color)
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

struct MediumWidgetView: View {
    let aqiData: AQIData
    
    private var aqiColor: Color {
        guard let aqiValue = Int(aqiData.aqi) else { return .gray }
        switch aqiValue {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        default: return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .lastTextBaseline) {
                Text(aqiData.siteName)
                    .font(.system(.headline, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                StatusBadge(status: aqiData.status, color: aqiColor)
                    .padding(.trailing, -20)
            }
            .padding(.top, -5)
            .padding(.leading, -20)
            
            HStack(alignment: .lastTextBaseline) {
                Text(aqiData.aqi)
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(aqiColor)
                
                Text("(AQI)")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, -10)
            .padding(.leading, -20)
            
            // MARK: - 數值區
            HStack(alignment: .center, spacing: 20) {
                VStack(alignment: .center, spacing: 10) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("PM")
                            .font(.system(size: 13, weight: .bold))
                        Text("2.5")
                            .font(.system(size: 8))
                            .padding(.leading, -8)
                    }
                    Text(aqiData.pm25)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }
                
                VStack(alignment: .center, spacing: 10) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("PM")
                            .font(.system(size: 13, weight: .bold))
                        Text("10")
                            .font(.system(size: 8))
                            .padding(.leading, -8)
                    }
                    Text(aqiData.pm10)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }
                
                VStack(alignment: .center, spacing: 10) {
                    Text("O₃")
                        .font(.system(size: 13, weight: .bold))
                    Text(aqiData.o3)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }
                
                VStack(alignment: .center, spacing: 10) {
                    Text("CO")
                        .font(.system(size: 13, weight: .bold))
                    Text(aqiData.co)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }
                
                VStack(alignment: .center, spacing: 10) {
                    Text("SO₂")
                        .font(.system(size: 13, weight: .bold))
                    Text(aqiData.so2)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }
                
                VStack(alignment: .center, spacing: 10) {
                    Text("NO₂")
                        .font(.system(size: 13, weight: .bold))
                    Text(aqiData.no2)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.leading, -15)
            
        }
        .padding()
    }
}
