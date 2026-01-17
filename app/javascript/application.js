import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

const application = Application.start()
application.debug = false
window.Stimulus = application
eagerLoadControllersFrom("controllers", application)

export { application }

// 画像プレビュー機能
window.previewImage = function(input) {
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = function(e) {
      const preview = document.getElementById('preview');
      
      // 既存のコンテンツをクリア
      preview.innerHTML = '';
      
      // 新しい画像要素を作成
      const img = document.createElement('img');
      img.src = e.target.result;
      img.className = 'rounded-full object-cover border';
      img.style.width = '100px';
      img.style.height = '100px';
      
      preview.appendChild(img);
    }
    reader.readAsDataURL(input.files[0]);
  }
}