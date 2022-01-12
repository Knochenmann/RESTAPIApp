//
//  PlacesListViewController.swift
//  RESTAPIApp
//
//  Created by Егор Костюхин on 09.01.2022.
//

import UIKit

class PlacesListViewController: UIViewController {
    
    // MARK: - Private Properties:
    
    private var places: [Place] = []
    
    private let placesManager: PlacesProtocol = PlacesManager()
    private let coordenatesGenerator = CoordinatesGeneratorService()
    
    private let tableView: UITableView = {
        let tableVIew = UITableView()
        tableVIew.register(PlaceTableViewCell.self, forCellReuseIdentifier: PlaceTableViewCell.identifier)
        tableVIew.translatesAutoresizingMaskIntoConstraints = false
        return tableVIew
    }()
    
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView()
    
    private let generatePlaceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.orange.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 7
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    
    // MARK: - Life Cycle Methods:

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerSetup()
        tableViewSetup()
        refreshControlSetup()
        activityIndicatorSetup()
        generatePlaceButtonSetup()
        fetchPlaces()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        generatePlaceButton.layer.cornerRadius = 10
    }
    
    
    // MARK: - Private Methods:
    
    private func navigationControllerSetup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = StringService.PlacesList.title
    }
    
    private func refreshControlSetup() {
        refreshControl.addTarget(self, action: #selector(fetchPlaces), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(
            string: "Обновить список мест",
            attributes:
                [
                    NSAttributedString.Key.foregroundColor : UIColor.black
                ]
        )
        tableView.refreshControl = refreshControl
    }
    
    private func activityIndicatorSetup() {
        view.addSubview(activityIndicator)
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ]
        )
        activityIndicator.startAnimating()
        
    }
    
    @objc private func fetchPlaces() {
        placesManager.fetchPlaces { [unowned self] places in
            refreshControl.endRefreshing()
            guard let places = places else {
                showAlert(title: "Данные недоступны", message: "Попробуйте обновить данные чуть позже.")
                return
            }
            self.places = places
            activityIndicator.stopAnimating()
            tableView.reloadData()
        }
    }
    
    private func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 50
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
    }
    
    private func generatePlaceButtonSetup() {
        view.addSubview(generatePlaceButton)
        generatePlaceButton.setTitle(StringService.PlacesList.generatePlaceButtonTitle, for: .normal)
        generatePlaceButton.addTarget(self, action: #selector(generatePlaceButtonDidSelect), for: .touchUpInside)
        NSLayoutConstraint.activate(
            [
                generatePlaceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
                generatePlaceButton.heightAnchor.constraint(equalToConstant: 40),
                generatePlaceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                generatePlaceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            ]
        )
    }
    
    @objc private func generatePlaceButtonDidSelect() {
        let newPlace = Place(
            id: Int.random(in: 0...100),
            name: "NewPlace",
            latitude: coordenatesGenerator.latitude(),
            longitude: coordenatesGenerator.longitude()
        )
        activityIndicator.startAnimating()
        placesManager.push(place: newPlace) { [unowned self] place in
            guard let place = place else {
                activityIndicator.stopAnimating()
                showAlert(title: "Возникла ошибка", message: "Попробуйте повторить операцию позже.")
                return
            }
            activityIndicator.stopAnimating()
            places.append(place)
            tableView.insertRows(at: [IndexPath(row: places.count - 1, section: 0)], with: .automatic)
        }
    }
    
    private func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func deletePlace(at indexPath: IndexPath) {
        activityIndicator.startAnimating()
        let placeToDelete = places[indexPath.row]
        placesManager.removePlace(placeToDelete) { [unowned self] error in
            if let error = error {
                print(error)
                activityIndicator.stopAnimating()
                showAlert(title: "Возникла ошибка", message: "Не удалось удалить \(placeToDelete.name).")
                return
            }
            activityIndicator.stopAnimating()
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func showMap(for place: Place) {
        let placeVC = PlaceViewController()
        placeVC.place = place
        navigationController?.pushViewController(placeVC, animated: true)
    }
    
    deinit {
        print("PlacesListViewController has been dealocated.")
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource:

extension PlacesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.identifier, for: indexPath) as! PlaceTableViewCell
        cell.configure(with: places[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showMap(for: places[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePlace(at: indexPath)
        }
    }
    
}
