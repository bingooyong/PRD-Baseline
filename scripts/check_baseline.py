#!/usr/bin/env python3
"""
Baseline Compliance Checker
验证项目是否符合 Baseline 要求
"""

import yaml
import sys
import argparse
from pathlib import Path
from typing import List, Dict, Any


def load_baseline(baseline_path: Path) -> Dict[str, Any]:
    """加载 Baseline YAML 文件"""
    with open(baseline_path, 'r', encoding='utf-8') as f:
        return yaml.safe_load(f)


def check_requirements(baseline: Dict[str, Any], level: str = None) -> List[Dict]:
    """检查指定级别的要求"""
    requirements = baseline.get('requirements', [])
    results = []
    
    for req in requirements:
        req_level = req.get('level', '')
        req_id = req.get('id', '')
        req_title = req.get('title', '')
        
        # 如果指定了级别，只检查该级别
        if level and req_level != level:
            continue
        
        # 检查验证类型
        verification = req.get('verification', {})
        verification_type = verification.get('type', '')
        evidence = verification.get('evidence', '')
        
        results.append({
            'id': req_id,
            'title': req_title,
            'level': req_level,
            'verification_type': verification_type,
            'evidence': evidence,
            'status': 'pending'  # 实际应该检查证据是否存在
        })
    
    return results


def print_report(results: List[Dict], level: str = None):
    """打印检查报告"""
    level_filter = f" (Level: {level})" if level else ""
    print(f"\n{'='*60}")
    print(f"Baseline Compliance Report{level_filter}")
    print(f"{'='*60}\n")
    
    must_count = sum(1 for r in results if r['level'] == 'MUST')
    should_count = sum(1 for r in results if r['level'] == 'SHOULD')
    may_count = sum(1 for r in results if r['level'] == 'MAY')
    
    print(f"Total Requirements: {len(results)}")
    print(f"  MUST:  {must_count}")
    print(f"  SHOULD: {should_count}")
    print(f"  MAY:   {may_count}")
    print()
    
    print(f"{'ID':<12} {'Level':<8} {'Verification':<20} {'Status'}")
    print("-" * 60)
    
    for req in results:
        print(f"{req['id']:<12} {req['level']:<8} {req['verification_type']:<20} {req['status']}")
    
    print()


def main():
    parser = argparse.ArgumentParser(
        description='Check Baseline compliance'
    )
    parser.add_argument(
        '--baseline',
        type=Path,
        required=True,
        help='Path to Baseline YAML file'
    )
    parser.add_argument(
        '--level',
        choices=['MUST', 'SHOULD', 'MAY'],
        help='Filter by requirement level'
    )
    parser.add_argument(
        '--output',
        choices=['text', 'json', 'yaml'],
        default='text',
        help='Output format'
    )
    
    args = parser.parse_args()
    
    if not args.baseline.exists():
        print(f"Error: Baseline file not found: {args.baseline}")
        sys.exit(1)
    
    baseline = load_baseline(args.baseline)
    results = check_requirements(baseline, args.level)
    
    if args.output == 'text':
        print_report(results, args.level)
    elif args.output == 'json':
        import json
        print(json.dumps(results, indent=2, ensure_ascii=False))
    elif args.output == 'yaml':
        print(yaml.dump(results, allow_unicode=True, default_flow_style=False))


if __name__ == '__main__':
    main()
