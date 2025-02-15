import UIKit

struct Achievement {
    let title: String
    let description: String
    let iconName: String
    let color: UIColor
    var percentage = 100
    var dateOfCompletion: String?
    
    static var demoData: [Achievement] {
            return [
                Achievement(
                    title: "Мировой исследователь",
                    description: "Посетил 150+ стран на 6 континентах",
                    iconName: "globe.europe.africa.fill",
                    color: .systemTeal
                    ,dateOfCompletion: "11.02.2009"
                ),
                Achievement(
                    title: "Фотограф года",
                    description: "Выложил 1000+ фотографий с геолокациями",
                    iconName: "camera.aperture",
                    color: .systemOrange,
                    percentage: 85
                ),
                Achievement(
                    title: "Альпинист",
                    description: "Покорил 5 вершин выше 4000 метров",
                    iconName: "mountain.2.fill",
                    color: .systemIndigo,
                    dateOfCompletion: "23.10.2020"
                ),
                Achievement(
                    title: "Эко-герой",
                    description: "Собрал 50 кг мусора во время путешествий",
                    iconName: "leaf.fill",
                    color: .systemGreen,
                    percentage: 20
                ),
                Achievement(
                    title: "Фуд-эксперт",
                    description: "Попробовал 30 национальных блюд",
                    iconName: "fork.knife.circle.fill",
                    color: .systemRed,
                    percentage: 55
                ),
                Achievement(
                    title: "Культуролог",
                    description: "Посетил 20 музеев и исторических мест",
                    iconName: "books.vertical.fill",
                    color: .systemPurple,
                    dateOfCompletion: "19.03.2011"
                ),
                Achievement(
                    title: "Специалист",
                    description: "Прошёл 1000 тренировок",
                    iconName: "graduationcap.circle.fill",
                    color: .systemGray,
                    percentage: 10),
                Achievement(
                    title: "Администратор",
                    description: "Зарегистрировал 100 пользователей",
                    iconName: "person.badge.plus.fill",
                    color: .systemBlue,
                    dateOfCompletion: "12.04.2021"
                )
            ]
        }
}
