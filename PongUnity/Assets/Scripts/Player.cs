using System;
using UnityEngine;

namespace AssemblyCSharp
{
	public class Player : Role
	{
		public Player ()
		{
		}

		protected override void Logic() {
			if (controller.isGrounded) {
				float dx = Input.GetAxis ("Horizontal");
				float dz = Input.GetAxis ("Vertical");
				moveDirection = new Vector3 (dx, 0, dz).normalized;
				moveDirection *= speed;
				if (Input.GetButton ("Jump"))
					moveDirection.y = jumpSpeed;
				if (dx != 0 || dz != 0)
					faceDirection = moveDirection;
			}
			if (Input.GetButtonDown ("Fire1")) {
				ShowHit (true);
			}
			moveDirection.y -= gravity * Time.deltaTime;
			if (!(faceDirection.x == 0 && faceDirection.y == 0))
				transform.rotation = Quaternion.LookRotation (new Vector3(faceDirection.x, 0, faceDirection.z));
			controller.Move (moveDirection * Time.deltaTime);
//			Debug.Log(string.Format("moveDirection: {0},0,{1}", moveDirection.x, moveDirection.z));
		}

		protected override void ShowHit(bool hit) {
			base.ShowHit (hit);
		}
	}
}

