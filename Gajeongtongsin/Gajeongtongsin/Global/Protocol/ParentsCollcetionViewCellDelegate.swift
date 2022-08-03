//
//  ParentsCollcetionViewCellDelegate.swift
//  Gajeongtongsin
//
//  Created by Beone on 2022/07/29.
//

import Foundation

protocol ParentsCollcetionViewCellDelegate{
    func present(message: String )
    func drawDisplayData(cellSchedulData: [TeacherCalenderData])
}
