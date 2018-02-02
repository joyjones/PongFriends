using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace AssemblyCSharp
{
	public class Role : MonoBehaviour {

		public bool IsHitting {
			get { return elapsedHitTime >= 0; }
		}
		private List<Role> collidingRoles = new List<Role> ();
		public Role[] CollidingRoles {
			get { return collidingRoles.ToArray (); }
		}
		public void AddCollidingRole(Role role){
			if (!collidingRoles.Contains(role))
				collidingRoles.Add (role);
		}
		public void RemoveCollidingRole(Role role){
			collidingRoles.Remove (role);
		}
		// Use this for initialization
		void Start () {
			controller = GetComponent<CharacterController>();
			hitHeadInst = transform.Find ("Head").gameObject;
		}

		public float speed = 6.0F;
		public float jumpSpeed = 8.0F;
		public float gravity = 20.0F;

		protected CharacterController controller;
		protected Vector3 moveDirection = Vector3.zero;
		protected Vector3 faceDirection = Vector3.zero;
		protected GameObject hitHeadInst;

		private float elapsedHitTime = -1;

		private void Update() {
			if (elapsedHitTime >= 0) {
				elapsedHitTime += Time.deltaTime;
				if (elapsedHitTime > 0.1F)
					ShowHit (false);
			}
			Logic ();
		}

		protected virtual void Logic(){
		}

		protected virtual void ShowHit(bool hit) {
			hitHeadInst.transform.rotation = transform.rotation;
			var dir = faceDirection;
			dir.y = 0;
			var pos = transform.position;
			pos.y += 1.4F;
			if (hit)
				hitHeadInst.transform.position = pos + dir * 0.3F;
			else
				hitHeadInst.transform.position = pos;
			elapsedHitTime = hit ? 0 : -1;
		}

		public void HitBody(string oppName){
			Debug.Log (oppName + " hitted me!");
		}

		void OnCollisionEnter(Collision collision) {
			Debug.Log ("OnCollisionEnter:" + collision.ToString ());
		}
		void OnCollisionExit(Collision collision) {
			Debug.Log ("OnCollisionExit:" + collision.ToString ());
		}
		void OnCollisionStay(Collision collision) {
			Debug.Log ("OnCollisionStay:" + collision.ToString ());
		}

		void OnTriggerEnter(Collider collider) {
	//		Debug.Log("开始接触");
		}

		void OnTriggerExit(Collider collider) {
	//		Debug.Log("接触结束");
		}

		void OnTriggerStay(Collider collider) {
	//		Debug.Log("接触持续中");
		}
	}
}