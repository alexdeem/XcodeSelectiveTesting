import Foundation
import PathKit

struct Changeset {
    let changedPaths: Set<Path>
    
    static func gitChangeset(at path: Path, baseBranch: String) throws -> Changeset {
        let currentBranch = try shell("cd \(path) && git branch --show-current")
        
        guard !currentBranch.isEmpty else {
            throw ChangesetError.missingCurrentBranch
        }
        
        let changes = try shell("cd \(path) && git diff \(baseBranch)..\(currentBranch) --name-only")
        let changesAsSet = Set(changes.components(separatedBy: .newlines).map { Path($0) } )
        
        return Changeset(changedPaths: changesAsSet)
    }
    
    enum ChangesetError: String, Error {
        case missingCurrentBranch = "missingCurrentBranch"
    }
}
