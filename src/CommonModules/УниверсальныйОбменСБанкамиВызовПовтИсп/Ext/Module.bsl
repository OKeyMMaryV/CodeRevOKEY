﻿// Возвращает заданные реквизиты организации.
// Параметры:
//   Организация - СправочникСсылка.Организации - ссылка на организацию;
//   Реквизиты   - Строка - список реквизитов, разделенные запятыми.
// Возвращаемое значение:
//   Структура - структура с ключами, определяемыми строкой Реквизиты.
//
Функция РеквизитыОрганизации(Организация, Реквизиты) Экспорт
	
	Результат = Новый Структура;
	
	УниверсальныйОбменСБанкамиПереопределяемый.РеквизитыОрганизации(Организация, Реквизиты, Результат);
	
	Возврат Результат;
	
КонецФункции