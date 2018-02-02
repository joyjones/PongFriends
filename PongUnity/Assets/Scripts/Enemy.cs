using System;
using UnityEngine;

namespace AssemblyCSharp
{
	public class Enemy : Role
	{
		public Enemy ()
		{
		}

		protected override void Logic() {
		}

		protected override void ShowHit(bool hit) {
			base.ShowHit (hit);
		}
	}
}

