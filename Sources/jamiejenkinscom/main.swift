import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct jamiejenkinscom: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        // case about
        //case social
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
        var updated: Date?
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://jamiejenkins.com")!
    var name = "JamieJenkins.com"
    var description = "Nerdy & Wordy"
    var language: Language { .english }
    var imagePath: Path? { "images/avatar.png" }
}

// This will generate website using my own Empire theme:
try jamiejenkinscom().publish(withTheme: .empire)
