/**
*  Publish
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/
import Foundation
import Publish
import Plot

public extension Theme {
    /// Copied from the default "Foundation" theme that Publish ships with, a very
    /// basic theme mostly implemented for demonstration purposes.
    static var empire: Self {
        Theme(
            htmlFactory: EmpireHTMLFactory(),
            resourcePaths: ["Resources/EmpireTheme/styles.css"]
        )
    }
}

private struct EmpireHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .itemList(
                        for: context.allItems (
                            sortedBy: \.lastModified,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footerWithIcons(for: context.items(taggedWith: "footer", sortedBy: \.title ), on: context.site)
            )
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body(
                .header(for: context, selectedSection: section.id),
                .wrapper(
                    .itemList(for: section.items, on: context.site)
                ),
                .footerWithIcons(for: context.items(taggedWith: "footer", sortedBy: \.title ), on: context.site)
            )
        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .header(for: context, selectedSection: item.sectionID),
                .wrapper(
                    .article(
                        .h1(.text(item.title)),
                        .p(.text(item.description)),
                        .div(
                            .class("content"),
                            .contentBody(item.body)
                        ),
                        .tagList(for: item, on: context.site),
                        .p(.class("postedon"), "Posted: ", "\(getFormattedDate(date: item.date))"),
                        .if(getFormattedDate(date: item.date) != getFormattedDate(date: item.lastModified),
                          .p(.class("updatedon"), "Updated: ", "\(getFormattedDate(date: item.lastModified))")
                        )
                    )
                ),
                .footerWithIcons(for: context.items(taggedWith: "footer", sortedBy: \.title ), on: context.site)
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(),
                    .div(
                            .class("content"),
                            .contentBody(page.body)
                        )                    
                ),
                .footerWithIcons(for: context.items(taggedWith: "footer", sortedBy: \.title ), on: context.site)
            )
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1("Browse all tags"),
                    .ul(
                        .class("tag-list"),
                        .forEach(page.tags.sorted().filter {$0 != "footer"}) { tag in
                            .li(
                                .class("tag-"+tag.string),
                                .a(
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            )
                        }
                    )
                ),
                .footerWithIcons(for: context.items(taggedWith: "footer", sortedBy: \.title ), on: context.site)
            )
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(
                        "Tagged with ",
                        .span(.class("tag-"+page.tag.string), .text(page.tag.string))
                    ),
                    .a(
                        .class("browse-all"),
                        .text("Browse all tags"),
                        .href(context.site.tagListPath)
                    ), 
                    .itemList(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.lastModified,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footerWithIcons(for: context.items(taggedWith: "footer", sortedBy: \.title ), on: context.site)
            )
        )
    }
   
  
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }

    static func header<T: Website>(for context: PublishingContext<T>, selectedSection: T.SectionID? ) -> Node {
        let allSectionIDs = T.SectionID.allCases
        let shownSectionIDs = allSectionIDs.dropFirst() // this removes footer section as it should be first
        return .header(
            .wrapper(
                .a(.class("site-name"), .href("/"), .text(context.site.name)),
                .p(.class("description"), .text(context.site.description)),
                .if(shownSectionIDs.count > 1,
                    .nav(
                        .ul(.forEach(shownSectionIDs) { section in
                            .li(.a(
                                .class(section == selectedSection ? "selected" : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].description)
                                ))
                        })
                    )
                )
            )
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        let allSectionIDs = T.SectionID.allCases
        let shownSectionIDs = allSectionIDs.dropFirst() // this removes footer section as it should be first
        let shownItems = items.filter { shownSectionIDs.contains($0.sectionID) }
        return .ul(
            .class("item-list"),
            .forEach(shownItems) { item in
                .li (.article(
                    .h1(.a( .href(item.path), .text(item.title) )),
                    .p(.text(item.description)),
                    .div(
                        .class("content"),
                        .contentBody(item.body)
                    ),
                    .tagList(for: item, on: site),
                    .p(.class("postedon"), "Posted: ", "\(getFormattedDate(date: item.date))"),
                    .if(getFormattedDate(date: item.date) != getFormattedDate(date: item.lastModified),
                      .p(.class("updatedon"), "Updated: ", "\(getFormattedDate(date: item.lastModified))")
                    )
                    ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        let allTags = item.tags
        let shownTags = allTags.filter { $0 != "footer" }
        return .ul(.class("tag-list"), .forEach(shownTags) { tag in
            .li(.class("tag-"+tag.string), .a(
                .href(site.path(for: tag)),
                .text(tag.string)
            ))
        })
    }
   

    static func footerWithIcons<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .footer(
            .span(.class("footer-list"),
                  .forEach(items) { item in
                    .span(.class("footer-icon"), .contentBody(item.body))
                    }
                ),
            .p( .class("copyright"), .text("©"+getFormattedYear()+" "+site.name)),
            .p( .class("generatedby"), .a(.text("Publish"), .href("https://github.com/johnsundell/publish")))
        )

    }

    static func getFormattedYear() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        return format.string(from: date)
    }
   
}

func getFormattedDate(date: Date) -> String {
    let dateformat = DateFormatter()
    dateformat.dateFormat = "MMMM d, yyyy"
    return dateformat.string(from: date)
}

