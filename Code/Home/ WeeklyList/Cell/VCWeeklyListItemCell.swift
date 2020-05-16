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
    func textViewDidChange(title: String, indexPath: IndexPath)
    func updateIsComplete(isComplete: Bool, indexPath: IndexPath)
}

// MARK: - VCWeeklyListItemCell
class VCWeeklyListItemCell: UITableViewCell {
    static let identifier: String = "VCWeeklyListItemCell"
    weak var delegate: VCWeeklyListItemCellDelegate?
    var titleText: String?
    var previousRect: CGRect?
    var indexPath: IndexPath?
    
    private let fontHeight: CGFloat = 18
    private let margin: CGFloat = 12
    private var tvWriteConstraint: NSLayoutConstraint?

    lazy var checkBox = UICheckBox()
    
    var title: UILabel? = nil
    var tvWrite: UITextView? = nil
    var vwDummy: UIView? = nil
    
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
        checkBox.isUserInteractionEnabled = true
        checkBox.delegate = self
        
        addSubview(checkBox)
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: 48),
            checkBox.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
    
    // MARK: - remve view
    func removeSubViews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    // MARK: - Incomplete UI
    func setUpIncompleteUI(_ text: String = "") {
        removeSubViews()
        setUpCommonUI()
        
        self.title = UILabel()
        
        guard let title = self.title else { return }
        
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
        guard let title = self.title else { return }
        guard let text = titleText else { return }
        title.attributedText = nil
        title.text = text
    }
    
    // MARK: - Complete UI
    func setUpCompleteUI(_ text: String) {
        setUpIncompleteUI(text)
        setCompleted()
    }
    
    func setCompleted() {
        guard let title = self.title else { return }
        guard let text = titleText else { return }
        title.text = ""
        let attributeString = text.strikeThrough()
        title.attributedText = attributeString
    }
    
    // MARK: - Input UI
    func setUpInputUI(_ text: String) {
        removeSubViews()
        setUpCommonUI()
        
        self.tvWrite = UITextView()
        self.vwDummy = UIView()
        
        guard let tvWrite = self.tvWrite else { return }
        guard let vwDummy = self.vwDummy else { return }
        
        tvWrite.translatesAutoresizingMaskIntoConstraints = false
        tvWrite.setContents()
        tvWrite.delegate = self
        tvWrite.text = text
        
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
        
        // TODO: - 큐를 뒤로 미룰 수 있는 방법 알게되면 고치기
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            tvWrite.becomeFirstResponder()
        }
    }
}

// MARK: - CheckBoxDelegate
extension VCWeeklyListItemCell: CheckBoxDelegate {
    func CheckBox(isOn: Bool) {
        guard let indexPath = self.indexPath else { return }
        delegate?.updateIsComplete(isComplete: isOn, indexPath: indexPath)
    }
}

// MARK: - UITextViewDelegate
extension VCWeeklyListItemCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView == self.tvWrite else { return }
        
        if let indexPath = indexPath {
            delegate?.textViewDidChange(title: textView.text, indexPath: indexPath)
        }
        
        tvWriteConstraint?.constant = textView.contentSize.height
        delegate?.updateCellHeight()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView == self.tvWrite else { return }
        
        if let indexPath = indexPath {
            delegate?.textViewDidChange(title: textView.text, indexPath: indexPath)
        }
        
        let pos = textView.endOfDocument
        let currentRect = textView.caretRect(for: pos)
        
        guard let previousRect = self.previousRect else {
            self.previousRect = currentRect
            return
        }
        
        if currentRect.origin.y != previousRect.origin.y {
            tvWriteConstraint?.constant = textView.contentSize.height
            delegate?.updateCellHeight()
            self.previousRect = currentRect
        }
    }
}
