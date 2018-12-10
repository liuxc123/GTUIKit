//
//  FormDemoViewController.swift
//  GTCatalog
//
//  Created by liuxc on 2018/12/10.
//

import UIKit
import GTUIKit

class FormDemoViewController: GTUIFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Form"

        initializeForm()
    }

    func initializeForm() {

        let form : GTUIFormDescriptor
        var section : GTUIFormSectionDescriptor
        var row : GTUIFormRowDescriptor

        form = GTUIFormDescriptor(title: "Add Event")

        section = GTUIFormSectionDescriptor.formSection()
        form.addFormSection(section)

        // Title
        row = GTUIFormRowDescriptor(tag: "title", rowType: GTUIFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Title"
        row.isRequired = true
        section.addFormRow(row)

        // Location
        row = GTUIFormRowDescriptor(tag: "location", rowType: GTUIFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Location"
        section.addFormRow(row)

        section = GTUIFormSectionDescriptor.formSection()
        form.addFormSection(section)

        // All-day
        row = GTUIFormRowDescriptor(tag: "all-day", rowType: GTUIFormRowDescriptorTypeBooleanSwitch, title: "All-day")
        section.addFormRow(row)

        // Starts
        row = GTUIFormRowDescriptor(tag: "starts", rowType: GTUIFormRowDescriptorTypeDateTimeInline, title: "Starts")
        row.value = Date(timeIntervalSinceNow: 60*60*24)
        section.addFormRow(row)

        // Ends
        row = GTUIFormRowDescriptor(tag: "ends", rowType: GTUIFormRowDescriptorTypeDateTimeInline, title: "Ends")
        row.value = Date(timeIntervalSinceNow: 60*60*25)
        section.addFormRow(row)

        section = GTUIFormSectionDescriptor.formSection()
        form.addFormSection(section)

        // Repeat
        row = GTUIFormRowDescriptor(tag: "repeat", rowType:GTUIFormRowDescriptorTypeSelectorPush, title:"Repeat")
        row.value = GTUIFormOptionsObject(value: 0, displayText: "Never")
        row.selectorTitle = "Repeat"
        row.selectorOptions = [GTUIFormOptionsObject(value: 0, displayText: "Never"),
                               GTUIFormOptionsObject(value: 1, displayText: "Every Day"),
                               GTUIFormOptionsObject(value: 2, displayText: "Every Week"),
                               GTUIFormOptionsObject(value: 3, displayText: "Every 2 Weeks"),
                               GTUIFormOptionsObject(value: 4, displayText: "Every Month"),
                               GTUIFormOptionsObject(value: 5, displayText: "Every Year")]
        section.addFormRow(row)

        section = GTUIFormSectionDescriptor.formSection()
        form.addFormSection(section)

        // Alert
        row = GTUIFormRowDescriptor(tag: "alert", rowType:GTUIFormRowDescriptorTypeSelectorPush, title:"Alert")
        row.value = GTUIFormOptionsObject(value: 0, displayText: "None")
        row.selectorTitle = "Event Alert"
        row.selectorOptions = [
            GTUIFormOptionsObject(value: 0, displayText: "None"),
            GTUIFormOptionsObject(value: 1, displayText: "At time of event"),
            GTUIFormOptionsObject(value: 2, displayText: "5 minutes before"),
            GTUIFormOptionsObject(value: 3, displayText: "15 minutes before"),
            GTUIFormOptionsObject(value: 4, displayText: "30 minutes before"),
            GTUIFormOptionsObject(value: 5, displayText: "1 hour before"),
            GTUIFormOptionsObject(value: 6, displayText: "2 hours before"),
            GTUIFormOptionsObject(value: 7, displayText: "1 day before"),
            GTUIFormOptionsObject(value: 8, displayText: "2 days before")]
        section.addFormRow(row)


        section = GTUIFormSectionDescriptor.formSection()
        form.addFormSection(section)

        // Show As
        row = GTUIFormRowDescriptor(tag: "showAs", rowType:GTUIFormRowDescriptorTypeSelectorPush, title:"Show As")
        row.value = GTUIFormOptionsObject(value: 0, displayText: "Busy")
        row.selectorTitle = "Show As"
        row.selectorOptions = [GTUIFormOptionsObject(value: 0, displayText:"Busy"),
                               GTUIFormOptionsObject(value: 1, displayText:"Free")]
        section.addFormRow(row)

        section = GTUIFormSectionDescriptor.formSection()
        form.addFormSection(section)

        // URL
        row = GTUIFormRowDescriptor(tag: "url", rowType:GTUIFormRowDescriptorTypeURL)
        row.cellConfigAtConfigure["textField.placeholder"] = "URL"
        section.addFormRow(row)

        // Notes
        row = GTUIFormRowDescriptor(tag: "notes", rowType:GTUIFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure["textView.placeholder"] = "Notes"
        section.addFormRow(row)

        self.form = form
    }

    // MARK: GTUIFormDescriptorDelegate
    override func formRowDescriptorValueHasChanged(_ formRow: GTUIFormRowDescriptor!, oldValue: Any!, newValue: Any!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        if formRow.tag == "alert" {
            if !((formRow.value! as AnyObject).valueData() as AnyObject).isEqual(0) && ((oldValue as AnyObject).valueData() as AnyObject).isEqual(0) {

                let newRow = formRow.copy() as! GTUIFormRowDescriptor
                newRow.tag = "secondAlert"
                newRow.title = "Second Alert"
                form.addFormRow(newRow, afterRow:formRow)
            }
            else if !((oldValue as AnyObject).valueData() as AnyObject).isEqual(0) && ((newValue as AnyObject).valueData() as AnyObject).isEqual(0) {
                form.removeFormRow(withTag: "secondAlert")
            }
        }
        else if formRow.tag == "all-day" {
            let startDateDescriptor = form.formRow(withTag: "starts")!
            let endDateDescriptor = form.formRow(withTag: "ends")!
            let dateStartCell: GTUIFormDateCell = startDateDescriptor.cell(forForm: self) as! GTUIFormDateCell
            let dateEndCell: GTUIFormDateCell = endDateDescriptor.cell(forForm: self) as! GTUIFormDateCell
            if (formRow.value! as AnyObject).valueData() as? Bool == true {
                dateStartCell.formDatePickerMode = .date
                dateEndCell.formDatePickerMode = .date
            }
            else{
                dateStartCell.formDatePickerMode = .dateTime
                dateEndCell.formDatePickerMode = .dateTime
            }
            updateFormRow(startDateDescriptor)
            updateFormRow(endDateDescriptor)
        }
        else if formRow.tag == "starts" {
            let startDateDescriptor = form.formRow(withTag: "starts")!
            let endDateDescriptor = form.formRow(withTag: "ends")!
            if (startDateDescriptor.value! as AnyObject).compare(endDateDescriptor.value as! Date) == .orderedDescending {
                // startDateDescriptor is later than endDateDescriptor
                endDateDescriptor.value = Date(timeInterval: 60*60*24, since: startDateDescriptor.value as! Date)
                endDateDescriptor.cellConfig.removeObject(forKey: "detailTextLabel.attributedText")
                updateFormRow(endDateDescriptor)
            }
        }
        else if formRow.tag == "ends" {
            let startDateDescriptor = form.formRow(withTag: "starts")!
            let endDateDescriptor = form.formRow(withTag: "ends")!
            let dateEndCell = endDateDescriptor.cell(forForm: self) as! GTUIFormDateCell
            if (startDateDescriptor.value! as AnyObject).compare(endDateDescriptor.value as! Date) == .orderedDescending {
                // startDateDescriptor is later than endDateDescriptor
                dateEndCell.update()
                let newDetailText =  dateEndCell.detailTextLabel!.text!
                let strikeThroughAttribute = [NSAttributedStringKey.strikethroughStyle : NSUnderlineStyle.styleSingle.rawValue]
                let strikeThroughText = NSAttributedString(string: newDetailText, attributes: strikeThroughAttribute)
                endDateDescriptor.cellConfig["detailTextLabel.attributedText"] = strikeThroughText
                updateFormRow(endDateDescriptor)
            }
            else{
                let endDateDescriptor = self.form.formRow(withTag: "ends")!
                endDateDescriptor.cellConfig.removeObject(forKey: "detailTextLabel.attributedText")
                updateFormRow(endDateDescriptor)
            }
        }
    }

    @objc func cancelPressed(_ button: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }


    @objc func savePressed(_ button: UIBarButtonItem){
        let validationErrors : Array<NSError> = formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            showFormValidationError(validationErrors.first)
            return
        }
        tableView.endEditing(true)
    }


}

extension FormDemoViewController {
    @objc class func catalogMetadata() -> [String: Any] {
        return [
            "breadcrumbs": ["Form"],
            "primaryDemo": true,
            "presentable": true
        ]
    }
}
