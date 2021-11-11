﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ВедущийОбъект", ОбъектВладелец);
	Если Не ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Если объект еще не заблокирован для изменений и есть права на изменение набора
	// попытаемся установить блокировку.
	Если НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхФизическихЛицЗарплатаКадры") Тогда
		
		ТолькоПросмотр = Истина;
		
	КонецЕсли; 
	
	Если ТолькоПросмотр Тогда
		СотрудникиКлиентСервер.УстановитьРежимТолькоПросмотрВФормеРедактированияИстории(ЭтотОбъект);
	КонецЕсли;
	
	Для Каждого ЗаписьНабора Из Параметры.МассивЗаписей Цикл
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ЗаписьНабора);
	КонецЦикла;
	
	НаборЗаписей.Сортировать("Период");
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(НаборЗаписей, "Период", "ПериодСтрокой");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(НаборЗаписей, "ДатаРегистрацииИзменений", "ДатаРегистрацииИзмененийСтрокой");
	
	ДатаОтсчетаПериодическихСведений = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведенийСПериодомМесяц();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Набор = РеквизитФормыВЗначение("НаборЗаписей");
	Если Не Набор.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		Сообщения = ПолучитьСообщенияПользователю(Истина);
		Если Сообщения <> Неопределено Тогда
			Для каждого ПолученноеСообщение Из Сообщения Цикл
				ПолученноеСообщение.КлючДанных = Неопределено;
				ПолученноеСообщение.Сообщить();
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередНачаломИзменения(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередУдалением(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		Если НоваяСтрока Тогда
		
			Элемент.ТекущиеДанные.ФизическоеЛицо = ОбъектВладелец;
			Элемент.ТекущиеДанные.ВидЗастрахованногоЛица = ПредопределенноеЗначение("Перечисление.ВидыЗастрахованныхЛицОбязательногоСтрахования.ГражданеРФ");
			НовыйПериод = НачалоМесяца(ОбщегоНазначенияКлиент.ДатаСеанса());
			Если НаборЗаписей.Количество() > 1 Тогда
				ПоследнийПериод = НаборЗаписей.Получить(НаборЗаписей.Количество() - 2).Период;
			Иначе
				ПоследнийПериод = '00010101000000';
			КонецЕсли; 
			Если НовыйПериод <= ПоследнийПериод Тогда
				НовыйПериод = ДобавитьМесяц(ПоследнийПериод, 1);
			КонецЕсли; 
			Элемент.ТекущиеДанные.Период = НовыйПериод;
			Элемент.ТекущиеДанные.ДатаРегистрацииИзменений = НачалоМесяца(НовыйПериод);
			ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Элемент.ТекущиеДанные, "Период", "ПериодСтрокой");
			ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Элемент.ТекущиеДанные, "ДатаРегистрацииИзменений", "ДатаРегистрацииИзмененийСтрокой");
		
		Иначе
		
			ПериодПередНачаломИзменения = Элемент.ТекущиеДанные.Период;
			Если Элемент.ТекущиеДанные.Период = ДатаОтсчетаПериодическихСведений Тогда
				Элемент.ТекущиеДанные.Период = '00010101000000';
				ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Элемент.ТекущиеДанные, "Период", "ПериодСтрокой");
			КонецЕсли; 
			
			ДатаРегистрацииИзмененийПередНачаломИзменения = Элемент.ТекущиеДанные.ДатаРегистрацииИзменений;
			Если Элемент.ТекущиеДанные.ДатаРегистрацииИзменений = ДатаОтсчетаПериодическихСведений Тогда
				Элемент.ТекущиеДанные.ДатаРегистрацииИзменений = '00010101000000';
				ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Элемент.ТекущиеДанные, "ДатаРегистрацииИзменений", "ДатаРегистрацииИзмененийСтрокой");
			КонецЕсли; 
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		Если ОтменаРедактирования Тогда
			
			Элемент.ТекущиеДанные.Период = ПериодПередНачаломИзменения;
			ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Элемент.ТекущиеДанные, "Период", "ПериодСтрокой");
			
			Элемент.ТекущиеДанные.ДатаРегистрацииИзменений = ДатаРегистрацииИзмененийПередНачаломИзменения;
			ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Элемент.ТекущиеДанные, "ДатаРегистрацииИзменений", "ДатаРегистрацииИзмененийСтрокой");
			
		Иначе
					
			Если Не ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
				Элемент.ТекущиеДанные.Период = ДатаОтсчетаПериодическихСведений;
			КонецЕсли; 
	
			Если Не ЗначениеЗаполнено(Элемент.ТекущиеДанные.ДатаРегистрацииИзменений) Тогда
				Элемент.ТекущиеДанные.ДатаРегистрацииИзменений = ДатаОтсчетаПериодическихСведений;
			КонецЕсли; 
	
			Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
				СообщениеОбОшибке = НСтр("ru = 'Необходимо указать дату сведений'");
				ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке, , "НаборЗаписей.Период", , Отказ);
			Иначе
				НайденныеСтроки = НаборЗаписей.НайтиСтроки(Новый Структура("Период", Элемент.ТекущиеДанные.Период));
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					Если НайденнаяСтрока <> Элемент.ТекущиеДанные Тогда
						СообщениеОбОшибке = НСтр("ru = 'Уже есть запись с указанной датой сведений'");
						ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей.Период", , Отказ);
						Элемент.ТекущиеДанные.Период = '00010101000000';
						Прервать;
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли; 
			
			Если Не Отказ Тогда
				ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Элемент.ТекущиеДанные, "Период", "ПериодСтрокой");
				ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Элемент.ТекущиеДанные, "ДатаРегистрацииИзменений", "ДатаРегистрацииИзмененийСтрокой");
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеПериодическихСведенийКлиент.УпорядочитьНаборЗаписейВФорме(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПослеУдаления(Элемент)
	
	Если НаборЗаписей.Количество() = 0 Тогда
		ДобавитьЗаписьПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой", Модифицированность);
	
	УстановитьДатуРегистрацииИзмененийПоПериоду();
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("УстановитьДатуРегистрацииИзмененийПоПериоду", ЭтотОбъект);
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтотОбъект, Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой",, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой", Направление, Модифицированность);
	
	УстановитьДатуРегистрацииИзмененийПоПериоду();
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейДатаРегистрацииИзмененийПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(Элементы.НаборЗаписей.ТекущиеДанные, "ДатаРегистрацииИзменений", "ДатаРегистрацииИзмененийСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейДатаРегистрацииИзмененийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтотОбъект, Элементы.НаборЗаписей.ТекущиеДанные, "ДатаРегистрацииИзменений", "ДатаРегистрацииИзмененийСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейДатаРегистрацииИзмененийРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(Элементы.НаборЗаписей.ТекущиеДанные, "ДатаРегистрацииИзменений", "ДатаРегистрацииИзмененийСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейДатаРегистрацииИзмененийАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейДатаРегистрацииИзмененийОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		РедактированиеПериодическихСведенийКлиент.ОповеститьОЗавершении(ЭтотОбъект, "СтатусыЗастрахованныхФизическихЛиц", ОбъектВладелец);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьЗаписьПоУмолчанию()
	
	Запись = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(Запись, РегистрыСведений.СтатусыЗастрахованныхФизическихЛиц.СоздатьМенеджерЗаписи());
	Запись.ФизическоеЛицо = ОбъектВладелец;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДатуРегистрацииИзмененийПоПериоду(Результат = Истина, Параметр = Неопределено) Экспорт
	ТекущиеДанные = Элементы.НаборЗаписей.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.ДатаРегистрацииИзменений = НачалоМесяца(ТекущиеДанные.Период);
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ТекущиеДанные, "ДатаРегистрацииИзменений", "ДатаРегистрацииИзмененийСтрокой");
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Функция ЗаблокироватьОбъектВФормеВладельце()
	
	Возврат СотрудникиКлиент.ЗаблокироватьОбъектВФормеВладельцеПриРедактированииИстории(ЭтотОбъект);
	
КонецФункции

#КонецОбласти
