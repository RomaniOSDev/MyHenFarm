//
//  CoopCellView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import SwiftUI

struct CoopCellView: View {
    let coop: Coop
    var body: some View {
        HStack {
            if let image = convertDataToImage(coop.image) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 110, height: 110)
                    .cornerRadius(10)
            }else {
                Image(.coopDefault)
                    .resizable()
                    .frame(width: 110, height: 110)
                    .cornerRadius(10)
            }
            Spacer()
            VStack {
                Text(coop.titleCoop ?? "Coop")
                    .foregroundStyle(.black)
                    .font(.system(size: 24, weight: .bold))
                if let chikens = coop.chken?.allObjects as? [Chicken] {
                    Text("\(chikens.count) Chicken")
                        .foregroundStyle(.black)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.cornerRadius(10))
    }
    //MARK: - Converting data
    func convertDataToImage(_ data: Data?) -> UIImage? {
        guard let data else { return nil }
        return UIImage(data: data)
    }
}

#Preview {
    ZStack {
        Color.black
        CoopCellView(coop: Coop(context: MyHenFarmCoreDataManager.instance.context))
    }
}
