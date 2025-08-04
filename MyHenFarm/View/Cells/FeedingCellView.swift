//
//  FeedingCellView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 03.08.2025.
//

import SwiftUI

struct FeedingCellView: View {
    let feeding: Feeding
    var body: some View {
        HStack {
            Text(Dateformatter(date: feeding.date ?? Date()))
            Spacer()
            Text("\(feeding.type ?? "")")
        }
    }
    //MARK: - Dateformatter
    private func Dateformatter(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM   HH:mm"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    FeedingCellView(feeding: Feeding(context: MyHenFarmCoreDataManager.instance.context))
}
