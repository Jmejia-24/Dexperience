//
//  MovesTransition.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

enum MovesTransition {

    case moveDetail(String)

    var identifier: String {
        String(describing: self)
    }

    func coordinatorFor<R: MovesRouter>(router: R) -> Coordinator {
        return switch self {
        case .moveDetail(let movePath):
            MoveDetailCoordinator(router: router, movePath: movePath)
        }
    }
}
