//
//  PlanViewController.swift
//  Plans2.0
//
//  Created by Alex Pallozzi on 3/28/22.
//


import UIKit

// the plan view controller
class PlanViewController : UICollectionViewController {
    
    // get the data source of the view controller
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    // snapshot of the view controller
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>

    // the plan that the user views
    var plan: Plan {
        didSet {
            onChange(plan)
        }
    }
    // the plan a user would edit or create
    var workingPlan : Plan
    // checker to check if the user is adding a new plan
    var isAddingNewPlan = false
    // plan that will replace the old plan/be replaced?
    var onChange : (Plan) -> Void
    // data source instance
    private var dataSource : DataSource!
    
    // initializer for the view controller
    init(plan : Plan, onChange: @escaping (Plan) -> Void) {
        self.plan = plan         // initialize plan
        self.workingPlan = plan  // initialize the working plan to be the current plan
        self.onChange = onChange // initialize onChange
        var listConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped) // initialize the list config
        listConfig.showsSeparators = false          // the list config doesn't show the seperators
        listConfig.headerMode = .firstItemInSection // header is the first item in the section
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfig) // the list layout based on the list config
        super.init(collectionViewLayout: listLayout)    // call the super initializer using the new list layout
    }
    
    // plan view controller must be initialized
    required init?(coder: NSCoder) {
        fatalError("Always initialize PlanViewController using init(plan:)")
    }
    
    // display
    override func viewDidLoad() {
        super.viewDidLoad()
        // cell registration constant
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        // data source initializer
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        navigationItem.title = NSLocalizedString("Plan", comment: "Plan view controller title")
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateSnapshotForViewing()
    }
    
    // the editing checker
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing  {
            prepareForEditing()
        } else  { if isAddingNewPlan {
                onChange(workingPlan)
            } else {
                prepareForViewing()
            }
        }
    }
    
    // the cell registration handler
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath : IndexPath, row : Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case (_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case (.title, .editText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title)
        case (.day, .editDate(let day)):
            cell.contentConfiguration = dayConfiguration(for: cell, with: day)
        case (.start_date, .editTimeDate(let start_time)):
            cell.contentConfiguration = startTimeConfiguration(for: cell, with: start_time)
        case (.end_date, .editTimeDate(let end_time)):
            cell.contentConfiguration = endTimeConfiguration(for: cell, with: end_time)
        case (.address, .editText(let address)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: address)
        case (.notes, .editText(let notes)):
            cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
        default:
            fatalError("Unexpected combination of section and row.")
        }
        cell.tintColor = .purple
    }
    
    // check if the user cancelled the edit
    @objc func didCancelEdit() {
        workingPlan = plan
        setEditing(false, animated: true)
    }
    
    // update the snapshot to be in editing mode
    private func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .day, .start_date, .end_date, .address, .notes])
        snapshot.appendItems([.header(Section.title.nameOfTitle), .editText(plan.title)], toSection: .title)
        snapshot.appendItems([.header(Section.day.nameOfTitle), .editDate(plan.day)], toSection: .day)
        snapshot.appendItems([.header(Section.start_date.nameOfTitle), .editTimeDate(plan.startTime)], toSection: .start_date)
        snapshot.appendItems([.header(Section.end_date.nameOfTitle), .editTimeDate(plan.endTime)], toSection: .end_date)
        snapshot.appendItems([.header(Section.address.nameOfTitle), .editText(plan.address)], toSection: .address)
        snapshot.appendItems([.header(Section.notes.nameOfTitle), .editText(plan.notes)], toSection: .notes)
        dataSource.apply(snapshot)
    }
    
    // prepare the snapshot for editing
    private func prepareForEditing() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
        updateSnapshotForEditing()
    }
    
    // update the snapshot to be in view mode
    private func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.view])
        snapshot.appendItems([.header(""), .viewTitle, .viewDay, .viewStartTime, .viewEndTime, .viewAddress, .viewNotes], toSection: .view)
        dataSource.apply(snapshot)
    }
    
    // prepare the snapshot to be in editing mode
    private func prepareForViewing() {
        navigationItem.leftBarButtonItem = nil
        if workingPlan != plan {
            plan = workingPlan
        }
        updateSnapshotForViewing()
    }
    
    // section that returns a section for the given index path
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
}

extension PlanViewController {
    
    // the default configuration of a cell
    func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row) -> UIListContentConfiguration {
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = text(for: row)
        contentConfig.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfig.image = row.image
        return contentConfig
    }
    
    // the header configuration of a cell
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String?) -> UIListContentConfiguration {
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = title
        return contentConfig
    }
    
    // the configuration of a plan title cell, which is a text field
    func titleConfiguration(for cell: UICollectionViewListCell, with title: String?) -> TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = title
        contentConfiguration.onChange = { [weak self] title in
            self?.workingPlan.title = title
        }
        return contentConfiguration
    }
    
    // the start day and time configuration cell, which shows the start day and time
    func dayConfiguration(for cell: UICollectionViewListCell, with theDay: Date) -> DatePickerContentView.Configuration {
        var contentConfiguration = cell.datePickerConfiguration()
        contentConfiguration.date = theDay
        contentConfiguration.onChange = { [weak self] date_begin in
            self?.workingPlan.day = date_begin
        }
        return contentConfiguration
    }
    
    // the start time configuration of a cell
    func startTimeConfiguration(for cell: UICollectionViewListCell, with startTime: Date) -> StartTimePickerContentView.Configuration {
        var contentConfiguration = cell.startTimePickerConfiguration()
        contentConfiguration.start_time_val = startTime
        contentConfiguration.onChange = { [weak self] date_start in
            self?.workingPlan.startTime = date_start
        }
        return contentConfiguration
    }
    
    // the end time configuration of a cell
    func endTimeConfiguration(for cell: UICollectionViewListCell, with endingTime: Date) -> EndTimePickerContentView.Configuration {
        var contentConfiguration = cell.endTimePickerConfiguration()
        contentConfiguration.end_time_val = endingTime
        contentConfiguration.onChange = { [weak self] date_end in
            self?.workingPlan.endTime = date_end
        }
        return contentConfiguration
    }
    
    func addressConfiguration(for cell: UICollectionViewListCell, with address: String) -> AddressFieldContentView.Configuration {
        var contentConfiguration = cell.addressFieldConfiguration()
        contentConfiguration.addr_text = address
        contentConfiguration.onChange = { [weak self] address in
            self?.workingPlan.address = address
        }
        return contentConfiguration
    }
    
    // the configuration of the details/notes cell
    func notesConfiguration(for cell: UICollectionViewListCell, with notes: String?) ->  TextViewContentView.Configuration {
        var contentConfiguration = cell.textViewConfiguration()
        contentConfiguration.text = notes
        contentConfiguration.onChange = { [weak self] notes in
            self?.workingPlan.notes = notes
        }
        return contentConfiguration
    }
    
    // the text for a given row, depending on what row it is
    func text(for row: Row) -> String? {
        switch row {
        case .viewTitle: return plan.title
        case .viewDay: return plan.day.dayText
        case .viewStartTime: return plan.startTime.timeText
        case .viewEndTime: return plan.endTime.timeText
        case .viewAddress: return plan.address
        case .viewNotes: return plan.notes
        default: return nil
        }
    }
}
extension PlanViewController {
    
    // rows present in the plan view controller
    enum Row : Hashable {
        case header(String)       // header
        case viewTitle            // title
        case viewDay              // the day
        case viewStartTime        // start time
        case viewEndTime          // end time
        case viewAddress          // address
        case viewNotes            // notes
        case editText(String?)    // editing text
        case editDate(Date)       // editing day and time
        case editTimeDate(Date)   // editing just time
        
        // the type of image icon to use for the corresponding row
        var imageName : String? {
            switch self {
            case .viewDay: return "calendar.circle"
            case .viewStartTime: return "clock"
            case .viewEndTime: return "clock"
            case .viewAddress: return "globe.americas.fill"
            case .viewNotes: return "square.and.pencil"
            default: return nil
            }
        }
        
        // turns icons to the images
        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        // the text style of the row
        var textStyle: UIFont.TextStyle {
            switch self {
                case .viewTitle: return .headline
                default: return .subheadline
            }
        }
    }
    
}
extension PlanViewController {
    // the section enumeration
    enum Section: Int, Hashable {
        case view
        case title
        case day
        case start_date
        case end_date
        case address
        case notes
        
        // the title corresponding to the proper case
        var nameOfTitle: String {
        switch self {
        case .view: return ""
        case .title: return NSLocalizedString("Title", comment: "Title section title")
        case .day: return NSLocalizedString("Day", comment: "Day section title")
        case .start_date: return NSLocalizedString("Start Date", comment: "Start Date section title")
        case .end_date: return NSLocalizedString("End Date", comment: "End Date section title")
        case .address: return NSLocalizedString("Address", comment: "Address section title")
        case .notes: return NSLocalizedString("Notes", comment: "Notes section title")
        }
        }
    }
}

