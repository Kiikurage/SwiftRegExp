//
//  MTRegExp.swift
//  MTRegExp
//
//  Created by KikuraYuichirou on 2014/07/31.
//  Copyright (c) 2014年 KikuraYuichirou. All rights reserved.
//

import Foundation

public class MTRegExp {
	
	let regexp: NSRegularExpression
	let pattern: String
	
	public init(_ pattern: String) {
		self.pattern = pattern
		var error: NSError?
		
		self.regexp = NSRegularExpression.regularExpressionWithPattern(pattern,
			options: .CaseInsensitive, error: &error)
	}

	private func nativeMatch(input: String) -> [AnyObject]! {
		return self.regexp.matchesInString(input, options: nil, range: NSMakeRange(0, countElements(input)))
	}
	
	public func match(input: String) -> MTRegExpMatchResult {
		let match = self.nativeMatch(input)
		if (!match) {
			return MTRegExpMatchResult()
		}
		
		var res: MTRegExpMatchResult = MTRegExpMatchResult()
		
		let checkResults = match as [NSTextCheckingResult]
		for checkResult in checkResults {
			var textPart: [String] = []
			var rangePart: [Range<String.Index>] = []

			let max = checkResult.numberOfRanges
			
			for i in 0..<max {
				let nsRange = checkResult.rangeAtIndex(i)
				let range = Range<String.Index>(
					start: advance(input.startIndex, nsRange.location),
					end: advance(input.startIndex, nsRange.location+nsRange.length)
				)
				rangePart.append(range)
				textPart.append(input[range])
			}
			
			res.ranges.append(rangePart)
			res.texts.append(textPart)
		}
		
		return res
	}
	
	public func test(input: String) -> Bool {
		return self.nativeMatch(input).count > 0
	}
}

extension String {
	public func test (pattern: String) -> Bool {
		var regexp = MTRegExp(pattern)
		return regexp.test(self)
	}
	
	public func test (regexp: MTRegExp) -> Bool {
		return regexp.test(self)
	}

	public func match (pattern: String) -> MTRegExpMatchResult {
		var regexp = MTRegExp(pattern)
		return regexp.match(self)
	}

	public func match (regexp: MTRegExp) -> MTRegExpMatchResult {
		return regexp.match(self)
	}
}

public struct MTRegExpMatchResult {
	var ranges: [[Range<String.Index>]] = []
	var texts: [[String]] = []
}