using UnityEngine;
using System.Collections;

namespace AssemblyCSharp
{
	public class Head : MonoBehaviour
	{
		
		public Role ParentRole
		{
			get;
			private set;
		}

		public bool IsColliding
		{
			get;
			private set;
		}

		// Use this for initialization
		void Start ()
		{
			ParentRole = transform.parent.gameObject.GetComponentInChildren<Player> () as Role;
			if (ParentRole == null)
				ParentRole = transform.parent.gameObject.GetComponentInChildren<Enemy> () as Role;
		}
		
		// Update is called once per frame
		void Update ()
		{
		
		}

		void OnTriggerEnter(Collider collider)
		{
			if (collider.gameObject.name == "Head")
			{
				IsColliding = true;
				if (ParentRole.IsHitting)
				{
					var enemy = collider.gameObject.transform.parent.gameObject.GetComponentInChildren<Enemy> ();
					enemy.HitBody (this.name);
				}
			}
		}

		void OnTriggerExit(Collider collider) {
			IsColliding = false;
		}

		void OnTriggerStay(Collider collider) {
			//		Debug.Log("接触持续中");
		}
	}
}