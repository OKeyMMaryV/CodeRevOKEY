﻿&НаСервере
Перем КонтекстЭДОСервер;

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("ВидОтправляемогоДокумента", ВидОтправляемогоДокумента);
	Параметры.Свойство("Источник", Источник);
	Параметры.Свойство("ИсточникОтчета", ИсточникОтчета);
	Параметры.Свойство("КонецПериода", КонецПериода);
	Параметры.Свойство("НачалоПериода", НачалоПериода);
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ТекстВыгрузки", ТекстВыгрузки);
	
	Список.Параметры.УстановитьЗначениеПараметра("ВидОтчета", ВидОтправляемогоДокумента);
	Список.Параметры.УстановитьЗначениеПараметра("ИсточникОтчета", ИсточникОтчета);
	Список.Параметры.УстановитьЗначениеПараметра("Конец", КонецПериода);
	Список.Параметры.УстановитьЗначениеПараметра("Начало", НачалоПериода);
	Список.Параметры.УстановитьЗначениеПараметра("Организация", Организация);
	
	Попытка
		Запрос = Новый Запрос(Список.ТекстЗапроса);
		Запрос.УстановитьПараметр("ВидОтчета", ВидОтправляемогоДокумента);
		Запрос.УстановитьПараметр("ИсточникОтчета", ИсточникОтчета);
		Запрос.УстановитьПараметр("Конец", КонецПериода);
		Запрос.УстановитьПараметр("Начало", НачалоПериода);
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() = 1 Тогда 
			Выборка.Следующий();
			Источник = Выборка.Ссылка;
			Если ТипЗнч(Источник) = Тип("СправочникСсылка.ЭлектронныеПредставленияРегламентированныхОтчетов") Тогда 
				СписокВыборНаСервере_ЭлектронноеПредставление(Источник);
			ИначеЕсли ТипЗнч(Источник) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда 
				ЗаполнятьПриОткрытии = Истина;
			КонецЕсли;
		КонецЕсли;
	Исключение
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Не удалось получить электронное представление отчета'"));
		ЗаполнятьПриОткрытии = Ложь;
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗаполнятьПриОткрытии Тогда 
		СписокВыборНаКлиенте_РегОтчет(Источник);
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура СписокВыборНаСервере_ЭлектронноеПредставление(Ссылка)
	Попытка
		КонтекстЭДОСервер = КонтекстЭДОСервер(); 
		ИзвлеченныеФайлы = КонтекстЭДОСервер.ИзвлечьЭлектронныеПредставленияВХранилище(Ссылка, УникальныйИдентификатор);
		
		ОбъектовВАрхиве = 0;
		Если ИзвлеченныеФайлы <> Неопределено Тогда
			Для Каждого СвойстваФайла Из ИзвлеченныеФайлы Цикл
				Если СвойстваФайла.ВАрхиве Тогда 
					ОбъектовВАрхиве = ОбъектовВАрхиве + 1;
				КонецЕсли;
				ОпределитьНовыйФайлВТаблицеСвойствФайлов(СвойстваФайла.ИмяФайла, СвойстваФайла.ТипФайлаОтчетности, СвойстваФайла.Данные, СвойстваФайла.ВАрхиве);
			КонецЦикла;
		КонецЕсли;
		
		Если СвойстваФайлов.Количество() = 1 Тогда
			ОсновнойФайл = СвойстваФайлов[0];
		Иначе
			ОсновнойФайл = ПолучитьОсновнойФайл();
		КонецЕсли;
		
		ДанныеФайла = ПолучитьИзВременногоХранилища(ОсновнойФайл.АдресДанных);
		ФайлОсновногоПредставления = ПолучитьИмяВременногоФайла("xml");
		ДанныеФайла.Записать(ФайлОсновногоПредставления);
		АдресДанныхФайлаОсновногоПредставления = ОсновнойФайл.АдресДанных;
		ПредставлениеТекст = КонтекстЭДОСервер.ПрочитатьТекстИзФайла(ФайлОсновногоПредставления, ,Истина);
		УдалитьФайлы(ФайлОсновногоПредставления);
		
		ТекстВыгрузки.УстановитьТекст(ПредставлениеТекст);
		Источник = Ссылка;
	Исключение
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Не удалось получить электронное представление отчета'"));
		ТекстВыгрузки.УстановитьТекст("");
		Источник = Справочники.ЭлектронныеПредставленияРегламентированныхОтчетов.ПустаяСсылка();
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборНаКлиенте_РегОтчет(Ссылка)
	Попытка
		ФормаВыгрузкиРеглОтчета = ПолучитьФорму("Документ.ВыгрузкаРегламентированныхОтчетов.Форма.ФормаДокумента");
		СпДокОсн = Новый СписокЗначений;
		СпДокОсн.Добавить(Ссылка);
		ПредставлениеТекст = "";
		ФормаВыгрузкиРеглОтчета.СформироватьИЗаписать(СпДокОсн, ПредставлениеТекст);
		ТекстВыгрузки.УстановитьТекст(ПредставлениеТекст);
		Источник = Ссылка;
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не удалось получить электронное представление отчета'"));
		ТекстВыгрузки.УстановитьТекст("");
		Источник = ПредопределенноеЗначение("Документ.РегламентированныйОтчет.ПустаяСсылка");
	КонецПопытки;
КонецПроцедуры

&НаСервере
Функция КонтекстЭДОСервер()
	Если КонтекстЭДОСервер = Неопределено Тогда
		КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонецЕсли;
	
	Возврат КонтекстЭДОСервер;
КонецФункции

&НаСервере
Процедура ОпределитьНовыйФайлВТаблицеСвойствФайлов(ИмяФайла, ТипФайла, АдресДанных, Знач ВАрхиве = Ложь)
	НовСтр = СвойстваФайлов.Добавить();
	НовСтр.ИмяФайла = ИмяФайла;
	НовСтр.ТипФайлаОтчетности = ТипФайла;
	НовСтр.АдресДанных = АдресДанных;
	НовСтр.ВАрхиве = ВАрхиве;
КонецПроцедуры

&НаСервере
Функция ПолучитьОсновнойФайл()
	ОсновнойФайл = Неопределено;
	Для Каждого Стр Из СвойстваФайлов Цикл
		нрегРасширениеФайла = нрег(РасширениеФайла(стр.ИмяФайла));
		Если нрегРасширениеФайла = "xml" Тогда
			ОсновнойФайл = Стр;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОсновнойФайл;
КонецФункции

&НаСервере
Функция РасширениеФайла(стрИмяФайла)
	СтрДлинаИмяФайла = СтрДлина(стрИмяФайла);
	Для Инд = 1 По СтрДлинаИмяФайла Цикл
		ТекущийИндекс = СтрДлинаИмяФайла - Инд + 1;
		Если Сред(стрИмяФайла, ТекущийИндекс, 1) = "." Тогда
			Возврат Сред(стрИмяФайла, ТекущийИндекс + 1);
		КонецЕсли;
	КонецЦикла;
	Возврат "";
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбораФайлаПредидущегоПериода(ВыбранныеФайлы, ДопПараметры) Экспорт
	Если ТипЗнч(ВыбранныеФайлы) <> Тип("Массив")
		Или ВыбранныеФайлы.Количество() <> 1 Тогда 
		Возврат;
	КонецЕсли;
	
	ТекстФайла = Новый ЧтениеТекста(ВыбранныеФайлы[0]);
	ТекстВыгрузки.Очистить();
	Стр = "";
	Пока Стр <> Неопределено Цикл 
		Стр = ТекстФайла.ПрочитатьСтроку();
		ТекстВыгрузки.ДобавитьСтроку(Стр);
	КонецЦикла;
	ТекстФайла.Закрыть();
	Источник = Неопределено;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Вставить("ТекстВыгрузки", ТекстВыгрузки);
	ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Вставить("Источник", Источник);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ТипЗнч(Элемент.ТекущиеДанные.Ссылка) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
		СписокВыборНаКлиенте_РегОтчет(Элемент.ТекущиеДанные.Ссылка);
	ИначеЕсли ТипЗнч(Элемент.ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.ЭлектронныеПредставленияРегламентированныхОтчетов") Тогда 
		СписокВыборНаСервере_ЭлектронноеПредставление(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	СтандартнаяОбработка = Ложь;
	ДВФ = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДВФ.Заголовок = НСтр("ru = 'Выберите файл выгрузки'");
	ДВФ.Фильтр = НСтр("ru = 'Файл приложения (*.xml)|*.xml'");
	ДВФ.МножественныйВыбор = Ложь;
	ОО = Новый ОписаниеОповещения("ОбработкаВыбораФайлаПредидущегоПериода", ЭтотОбъект);
	ДВФ.Показать(ОО);
КонецПроцедуры

#КонецОбласти