//
//  PlaceTableViewCell.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 09.01.2022.
//

import UIKit


class PlaceTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties:
    
    static let identifier = "TableViewCell"
    
    // MARK: - Private Properties:
    
    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let coordinatesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.tintColor = .red
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.layer.masksToBounds = true
        return photoView
    }()
    
    
    // MARK: - Initializers:
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        labelStackSetup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods:
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    
    // MARK: - Public Methods:
    
    // Should be changed by using a clean architecture:
    func configure(with place: Place) {
        placeNameLabel.text = place.name
        coordinatesLabel.text = "\(place.latitude), \(place.longitude)"
        photoView.image = UIImage(systemName: "globe.americas.fill")
    }
    
    
    // MARK: - Private Methods:
    
    private func labelStackSetup() {
        labelsStack.addArrangedSubview(placeNameLabel)
        labelsStack.addArrangedSubview(coordinatesLabel)
    }
    
    private func layout() {
        // PhotoView Layout:
        contentView.addSubview(photoView)
        NSLayoutConstraint.activate(
            [
                photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                photoView.widthAnchor.constraint(equalTo: photoView.heightAnchor, multiplier: 1)
            ]
        )
        
        // LabelsStack Layout:
        contentView.addSubview(labelsStack)
        NSLayoutConstraint.activate(
            [
                labelsStack.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 8),
                labelsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                labelsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ]
        )
    }
    
}
