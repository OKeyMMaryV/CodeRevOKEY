﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураПараметров		=	ок_ОбщегоНазначенияФинансы21.ПолучитьПараметрыРегламентногоЗадания();
	СтруктураПараметров.Свойство("ДатаНачала",		Период.ДатаНачала);
	СтруктураПараметров.Свойство("ДатаОкончания",	Период.ДатаОкончания);
	
	ВидыОпераций.Добавить("Оплата сертификата",	"Оплата сертификата",	Истина);
	ВидыОпераций.Добавить("Оплата СТОЛОТО",		"Оплата СТОЛОТО", 		Истина);
	ВидыОпераций.Добавить("Оплата товара",		"Оплата товара", 		Истина);
	
	ВидыОплат.Добавить("Нал",					"Наличные",				Истина);
	ВидыОплат.Добавить("Безнал",				"Безналичные",			Истина);
	ВидыОплат.Добавить("Серт",					"Сертификат",			Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОписаниеОповещения	=	Новый ОписаниеОповещения("ЗагрузитьЗавершение", ЭтаФорма);
	
	ПоказатьВопрос(ОписаниеОповещения, "Загрузить помеченные строки?", РежимДиалогаВопрос.ДаНет, 10, 
		КодВозвратаДиалога.Нет, "Загрузка из Кристалл", КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	УстановитьПометки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	УстановитьПометки(Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура Декорация_ок_СопоставлениеАналитикиДляИнтеграцийНажатие(Элемент)
	ОткрытьФорму("РегистрСведений.ок_СопоставлениеАналитикиДляИнтеграций.ФормаСписка");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗагрузитьНаСервере() Тогда
		ТекстПредупреждения	=	"Загрузка выполнена успешно. Подробности в журнале логирования.";
	Иначе
		ТекстПредупреждения	=	"Загрузка выполнена с ошибками! Подробности в журнале логирования.";
	КонецЕсли;
	
	ПоказатьПредупреждение(, ТекстПредупреждения, , "Загрузка из Кристалл");	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ПараметрыЗагрузки	=	Новый Структура;
	ПараметрыЗагрузки.Вставить("ДатаНачала", 			Период.ДатаНачала);
	ПараметрыЗагрузки.Вставить("ДатаОкончания",			Период.ДатаОкончания);
	ПараметрыЗагрузки.Вставить("ВидыОпераций",			ок_ОбщегоНазначенияФинансы21.ВыгрузитьПомеченныеЗначенияСписка(ВидыОпераций));
	ПараметрыЗагрузки.Вставить("ВидыОплат",				ок_ОбщегоНазначенияФинансы21.ВыгрузитьПомеченныеЗначенияСписка(ВидыОплат));
	ПараметрыЗагрузки.Вставить("ИгнорироватьПериод",	ОтборИгнорироватьПериод);
	ПараметрыЗагрузки.Вставить("Объект",				ОтборОбъект);
	
	ИнтеграционнаяТаблица.Загрузить(ок_Кристалл_ЗагрузкаДанных.ПолучитьДанные(ПараметрыЗагрузки));
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьНаСервере()
	
	МассивСтрок	=	ИнтеграционнаяТаблица.НайтиСтроки(Новый Структура("Пометка", Истина));
	
	Возврат ок_Кристалл_ЗагрузкаДанных.ЗагрузитьТаблицу(ИнтеграционнаяТаблица.Выгрузить(МассивСтрок, 
				"ВидОперации, ВидОплаты, Дата, Объект, Сумма"));
	
КонецФункции

&НаКлиенте
Процедура УстановитьПометки(Пометка)
	
	Для Каждого Строка Из ИнтеграционнаяТаблица Цикл
		Строка.Пометка	=	Пометка;	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
