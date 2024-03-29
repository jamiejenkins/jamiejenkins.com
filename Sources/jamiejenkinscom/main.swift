import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct jamiejenkinscom: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        // footer should always be first so that it remains 'hidden'
        // and there should always be at minimum two sections
        case footer
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://jamiejenkins.com")!
    var name = "Jamie Jenkins"
    var description = "Nerdy (occasionally wordy)"
    var language: Language { .english }
    var imagePath: Path? { "images/avatar.png" }
}

// This will generate website using my own Empire theme:
try jamiejenkinscom().publish(withTheme: .empire)
