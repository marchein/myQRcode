//
//  Model.swift
//  myQRcode
//
//  Created by Marc Hein on 21.08.20.
//  Copyright © 2020 Marc Hein Webdesign. All rights reserved.
//

import Foundation

struct Segues {
    static let GenerateToTemplateSegue = "GenerateToTemplateSegue"
    static let EditTemplateSegue = "editTemplateSegue"
}

struct Model {
    static let Templates = [
        Template(name: NSLocalizedString("wifi_template", comment: ""), templateString: "WIFI:T:%@;S:%@;P:%@;;", parameters: [NSLocalizedString("wifi_security", comment: ""), NSLocalizedString("wifi_name", comment: ""), NSLocalizedString("wifi_password", comment: "")], parameterType: [.Selector, .Text, .Text], options: [["nopass", "WEP", "WPA"], nil, nil]),
        Template(name: NSLocalizedString("email_template", comment: ""), templateString: "mailto:%@", parameters: [NSLocalizedString("email_address", comment: "")], parameterType: [.Text], options: [nil]),
        Template(name: NSLocalizedString("phone_template", comment: ""), templateString: "tel:%@", parameters: [NSLocalizedString("phone_number", comment: "")], parameterType: [.Text], options: [nil]),
        Template(name: NSLocalizedString("message_template", comment: ""), templateString: "sms:%@", parameters: [NSLocalizedString("message_number", comment: "")], parameterType: [.Text], options: [nil])
    ]
}
