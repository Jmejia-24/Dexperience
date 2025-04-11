//
//  ItemsTransition.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

enum ItemsTransition {

    case itemDetail(String)

    var identifier: String {
        String(describing: self)
    }

    func coordinatorFor<R: ItemsRouter>(router: R) -> Coordinator {
        return switch self {
        case .itemDetail(let stringUrl):
            ItemDetailCoordinator(router: router, stringUrl: stringUrl)
        }
    }
}
