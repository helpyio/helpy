//
// function setCookie(key, value) {
//   var expires = new Date();
//   expires.setTime(expires.getTime() + (1 * 24 * 60 * 60 * 1000));
//   document.cookie = key + '=' + value + ';path=/' + ';expires=' + expires.toUTCString();
// }
//
// function getCookie(key) {
//   var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');
//   return keyValue ? keyValue[2] : null;
// }
//
// // Define the tour!
// var tour = {
//   id: "tickets-index-tour",
//   steps: [
//     {
//       title: "Inbox",
//       content: "The inbox is where all new tickets arrive.",
//       target: document.getElementsByClassName('ticket-stats')[0],
//       placement: "bottom"
//     },
//     {
//       title: "Current tickets",
//       content: "Click on a ticket to see the conversation and details on the customer.  Click next to see the ticket!",
//       target: document.getElementsByClassName('topic')[0],
//       placement: "top",
//       onNext: function() {
//           $('a.topic-link-1').click();
//         }
//     },
//     {
//       title: "The ticket view",
//       content: "The ticket view shows the full history of a ticket, including information on the customer.",
//       target: document.getElementsByClassName('main-panel')[0],
//       placement: "bottom"
//     },
//     {
//       title: "Ticket Controls",
//       content: "Use these dropdowns to set the ticket status, assign an agent, group or ticket privacy.",
//       target: "ticket-controls",
//       placement: "top",
//       onNext: function() {
//           $('a.post_dropdown :first').click();
//         }
//     },
//     {
//       title: "Advanced options",
//       content: "Access advanced ticket options with this dropdown to split a ticket, change the author or create a common reply.",
//       target: document.getElementsByClassName('post-dropdown')[0],
//       placement: "left"
//     },
//     {
//       title: "Reply to tickets here",
//       content: "Use this to reply to a ticket or write an internal note. You can also select from your 'common replies'",
//       target: 'new_post',
//       placement: "top"
//     },
//     {
//       title: "Add a new ticket",
//       content: "Helpy supports multiple channels like email, phone, and chat.  To add a new ticket click here.",
//       target: document.getElementsByClassName('new-discussion')[0],
//       placement: "left"
//     },
//     {
//       title: "Your Profile and Settings",
//       content: "Click here to customize your profile, add your company logo and access all the other options in the settings panel.",
//       target: document.getElementsByClassName('admin-avatar')[0],
//       placement: "left"
//     },
//     {
//       title: "Universal Search",
//       content: "Locate tickets by ID, subject or content, or search for users.",
//       target: "q",
//       placement: "bottom"
//     }
//
//   ],
//   onEnd: function() {
//     setCookie("toured", "toured");
//   },
//   onClose: function() {
//     setCookie("toured", "toured");
//   }
// };
//
// // nitialize tour if it's the user's first time
// if (!getCookie("toured")) {
//   hopscotch.startTour(tour);
// }
