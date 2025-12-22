//
//  AWCalendarView.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct AWCalendarView: View {
    @ObservedObject var viewModel: AWOutfitsViewModel
    
    @State private var displayedMonth: Date = Date()
    
    private let calendar = Calendar.current
    @State var currentEvent: Event?
    @State private var showEventDetails = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Calendar")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    NavigationLink {
                        AWNewEventView(viewModel: viewModel)
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("+ Add event")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 8).padding(.horizontal, 11)
                            .background(.buttons)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }.padding(.horizontal, 20)
                
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(spacing: 10) {
                        monthHeader
                        weekdayHeader
                        monthGrid
                            .frame(height: 200)
                    }
                    .padding(.horizontal, 12).padding(.vertical, 16)
                    .background(.secondaryText)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.calendar)
                    }
                    
                    Text("Upcoming events:")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    eventsList
                    
                    
                }.padding(.horizontal, 20).padding(.top, 8)
                    .ignoresSafeArea(edges: .bottom)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
        }
        .background(.bg)
        .overlay {
            if let event = currentEvent, showEventDetails {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                        .onTapGesture {
                            currentEvent = nil
                        }
                    
                    VStack(alignment: .center) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(dateTitle(for: event.date))")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.buttons)
                                
                                Text("\(event.name)")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            
                            Text("\(event.type.rawValue)")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.calendar)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        if let outfit = event.outfit {
                            VStack {
                                ItemsCollageView(items: outfit.clothes)
                                Text("\(outfit.name)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        Button {
                            viewModel.delete(event: event)
                            currentEvent = nil
                        } label: {
                            Text("Delete")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(.vertical, 20).padding(.horizontal, 80)
                                .background(.deleteButton)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }.buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: UIScreen.main.bounds.height / 2.5)
                    .padding(.horizontal).padding(.vertical, 20)
                    .background(.bg)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 1.5)
                            .foregroundStyle(.calendar)
                    }
                    .padding(.horizontal)
                }
            }
        }
        
    }
    
    private var eventsList: some View {
        let monthEvents = eventsForDisplayedMonth()
        
        return Group {
            if monthEvents.isEmpty {
                Text("No events this month")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(monthEvents) { event in
                            Button {
                                currentEvent = event
                                showEventDetails = true
                                
                            } label: {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("\(dateTitle(for: event.date))")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(.buttons)
                                        
                                        Text("\(event.name)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(.white)
                                    }
                                    
                                    Text("\(event.type.rawValue)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.calendar)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            
                        }
                    }.padding(.bottom, 150)
                }
            }
        }
    }
    
    // Заголовок: месяц, год, стрелки
    private var monthHeader: some View {
        HStack(spacing: 15) {
            Text(monthTitle(for: displayedMonth))
                .font(.system(size: 20, weight: .medium))
            
            Spacer()
            Button {
                changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 15)
                    .bold()
            }
            
            Button {
                changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 15)
                    .bold()
            }
        }.foregroundStyle(.white)
    }
    
    // Заголовок дней недели
    private var weekdayHeader: some View {
        let symbols = calendar.veryShortWeekdaySymbols // Пн, Вт, ...
        
        return HStack {
            ForEach(0..<7, id: \.self) { index in
                Text(symbols[safe: (index + calendar.firstWeekday - 1) % 7] ?? "")
                    .font(.system(size: 20, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
            }
        }
    }
    
    // Сетка дней месяца
    private var monthGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(daysForMonth(), id: \.self) { date in
                if let date {
                    dayCell(for: date)
                } else {
                    // Пустая ячейка перед началом месяца
                    Color.clear
                        .frame(height: 40)
                }
            }
        }
    }
    
    private func eventsForDisplayedMonth() -> [Event] {
        viewModel.events
            .filter { event in
                calendar.isDate(event.date, equalTo: displayedMonth, toGranularity: .month)
            }
            .sorted { $0.date < $1.date }
    }
    
    // Одна ячейка дня
    private func dayCell(for date: Date) -> some View {
        let day = calendar.component(.day, from: date)
        let event = eventForDate(date)
        
        return VStack(spacing: 4) {
            
            // Маркер дайва
            if event {
                Circle()
                    .fill(.buttons)
                    .frame(width: 8, height: 8)
            } else {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 8, height: 8)
            }
            
            Text("\(day)")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.white)
            
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 25)
    }
    
    // MARK: - Логика
    
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newDate
        }
    }
    
    private func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "LLLL yyyy"  // например, "Январь 2025"
        return formatter.string(from: date).capitalized
    }
    
    private func dateTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "dd.LL.yyyy"  // например, "Январь 2025"
        return formatter.string(from: date).capitalized
    }
    
    /// Строим массив дат для текущего месяца с учётом пустых ячеек в начале
    private func daysForMonth() -> [Date?] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
            let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: monthInterval.start))
        else {
            return []
        }
        
        let range = calendar.range(of: .day, in: .month, for: firstDay) ?? 1..<2
        let numberOfDays = range.count
        
        // Смещение от начала недели (учитываем firstWeekday)
        let firstWeekdayOfMonth = calendar.component(.weekday, from: firstDay)
        let weekdayOffset = (firstWeekdayOfMonth - calendar.firstWeekday + 7) % 7
        
        var days: [Date?] = Array(repeating: nil, count: weekdayOffset)
        
        for day in 0..<numberOfDays {
            if let date = calendar.date(byAdding: .day, value: day, to: firstDay) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func eventForDate(_ date: Date) -> Bool {
        viewModel.events.contains { event in
            calendar.isDate(event.date, inSameDayAs: date)
        }
    }
}

// MARK: - Безопасный доступ к массиву (чтобы не вылетало с weekdaySymbols)

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}


#Preview {
    AWCalendarView(viewModel: AWOutfitsViewModel())
}


