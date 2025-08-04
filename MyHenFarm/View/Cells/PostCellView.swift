//
//  PostCellView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import SwiftUI

struct PostCellView: View {
    let post: PostCounting
    var body: some View {
        HStack {
            Text(Dateformatter(date: post.date ?? Date()))
            Spacer()
            Text("\(post.quantity)")
            Spacer()
            if let coop = post.coop?.titleCoop{
                Text(coop)
            }
        }.foregroundStyle(.black)
        
        
    }
    //MARK: - Dateformatter
    private func Dateformatter(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM HH:mm"
        return dateFormatter.string(from: date)
    }
}

