//
//  VCWeeklyListItemCell.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

protocol VCWeeklyListItemCellDelegate: class {
    func updateCellHeight()
}

// MARK: - VCWeeklyListItemCell

// TODO: - 완료 시 표기되는 셀
// TODO: - 미완료 시 표기되는 셀
// TODO: - 등록 시 표기되는 셀
class VCWeeklyListItemCell: UITableViewCell {
    static let identifier: String = "VCWeeklyListItemCell"
    weak var delegate: VCWeeklyListItemCellDelegate?
    var titleText: String?
    var previousRect: CGRect?
    
    private let fontHeight: CGFloat = 18
    private let margin: CGFloat = 12
    private var tvWriteConstraint: NSLayoutConstraint?

    lazy var checkBox = UICheckBox()
    
    lazy var title = UILabel()
    lazy var tvWrite = UITextView()
    lazy var vwDummy = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Check Box UI
    func setUpCommonUI() {
        backgroundColor = .clear
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.isUserInteractionEnabled = false
        
        addSubview(checkBox)
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: 48),
            checkBox.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
    
    // MARK: - Incomplete UI
    func setUpIncompleteUI(_ text: String = "") {
        setUpCommonUI()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = text
        titleText = text
        setIncompleted()
        title.setContents()
        
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            title.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
    }
    
    func setIncompleted() {
        guard let text = titleText else { return }
        self.title.attributedText = nil
        self.title.text = text
    }
    
    // MARK: - Complete UI
    func setUpCompleteUI(_ text: String) {
        setUpIncompleteUI(text)
        setCompleted()
        checkBox.isOn = true
    }
    
    func setCompleted() {
        guard let text = titleText else { return }
        self.title.text = ""
        let attributeString = text.strikeThrough()
        self.title.attributedText = attributeString
    }
    
    // MARK: - Input UI
    func setUpInputUI() {
        setUpCommonUI()
        
        tvWrite.translatesAutoresizingMaskIntoConstraints = false
        tvWrite.setContents()
        tvWrite.delegate = self
        
        vwDummy.translatesAutoresizingMaskIntoConstraints = false
        vwDummy.backgroundColor = .clear
        
        addSubview(vwDummy)
        addSubview(tvWrite)
        tvWriteConstraint = tvWrite.heightAnchor.constraint(equalToConstant: tvWrite.contentSize.height)
        NSLayoutConstraint.activate([
            tvWrite.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            tvWrite.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor),
            tvWrite.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            vwDummy.topAnchor.constraint(equalTo: tvWrite.bottomAnchor),
            vwDummy.leadingAnchor.constraint(equalTo: tvWrite.leadingAnchor),
            vwDummy.trailingAnchor.constraint(equalTo: tvWrite.trailingAnchor),
            vwDummy.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
        ])
        tvWriteConstraint?.isActive = true
    }
}

// MARK: - UITextViewDelegate
extension VCWeeklyListItemCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView == self.tvWrite else { return }
        if textView.text.count == 1 {
            textView.text = textView.text.replacingOccurrences(of: " ", with: "")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView == self.tvWrite else { return }
        if textView.text.count == 0 {
            textView.text = " "
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView == self.tvWrite else { return }
        
        let pos = textView.endOfDocument
        let currentRect = textView.caretRect(for: pos)
        
        guard let previousRect = self.previousRect else {
            self.previousRect = currentRect
            return
        }
        
        if currentRect.origin.y != previousRect.origin.y {
            tvWriteConstraint?.constant = tvWrite.contentSize.height
            delegate?.updateCellHeight()
            self.previousRect = currentRect
        }
    }
}
