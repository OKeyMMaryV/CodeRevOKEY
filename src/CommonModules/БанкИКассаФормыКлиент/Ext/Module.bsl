﻿
#Область ОбработчикиБаннераНДП

&НаКлиенте
Процедура ОбработатьСсылкуБаннераПредупреждениеОЗаполненииРеквизитовПлатежаНПД(Организация, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПомощникНПД" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("КонтекстныйВызов,Организация", Ложь, Организация);
		ОткрытьФорму("Обработка.ПомощникУплатыНПД.Форма.Форма", ПараметрыФормы);
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПерейтиВЛичныйКабинетНПД" Тогда
		СтандартнаяОбработка = Ложь;
		ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(
			ИнтеграцияСПлатформойСамозанятыеКлиентСервер.АдресСервиса());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПолучитьВыпискуБанка(Форма, НастройкиБанковскогоСчета, СтруктураПериода) Экспорт
	
	Форма.СоглашениеЭД    = НастройкиБанковскогоСчета.СоглашениеПрямогоОбменаСБанками;
	Форма.ПериодНачало    = СтруктураПериода.ДатаНачала;
	Форма.ПериодОкончание = СтруктураПериода.ДатаОкончания;
	
	ДополнительныеПараметры = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(СтруктураПериода);
	ДополнительныеПараметры.Вставить("БанковскийСчет", НастройкиБанковскогоСчета.БанковскийСчет);
	
	Если СтруктураПериода.Свойство("ОткрыватьФормуУточненияПериода") Тогда
		Если НастройкиБанковскогоСчета.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.СбербанкОнлайн")
			И УчетДенежныхСредствВызовСервера.НетДокументовДиректБанкСбербанк(
				НастройкиБанковскогоСчета.Организация, НастройкиБанковскогоСчета.БанковскийСчет) Тогда
			Оповещение = Новый ОписаниеОповещения("ПолучитьВыпискиПоПрямомуОбменуСБанкомЗавершение", Форма, ДополнительныеПараметры);
			ТекстПредупреждения =
				НСтр("ru = 'Запрос выписки за большой период может привести к длительному ожиданию и быть прерван банком,
				|если потребуется значительное время соединения.
				|
				|Рекомендуется разбить большой период загрузки на интервалы не более двух недель.'");
			ПоказатьПредупреждение(Оповещение, ТекстПредупреждения);
		Иначе
			Форма.ОткрытьФормуКлиентБанка(ДополнительныеПараметры);
		КонецЕсли;
	Иначе
		// Вызываем метод ЭДО
		// Выписка будет обработана в событии "ОбработкаВыбора"
		ОбменСБанкамиКлиент.ПолучитьВыпискуБанка(
			Форма.СоглашениеЭД, Форма.ПериодНачало, Форма.ПериодОкончание, Форма, Форма.НомерСчета);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовОтражениеДоходов

Процедура ОтражениеДоходаОбработкаВыбора(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	
	// Обработчик не должен вызываться из неподготовленных форм, поэтому вызовем исключение,
	// если вызывающая форма не соответствует требованиям.
	БанкИКассаФормыКлиентСервер.ПроверитьВозможностьОтраженияДоходов(Форма);
	
	УчетПСНКлиент.ОтражениеДоходаОбработкаВыбора(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОтражениеДоходаПриИзменении(Форма, ИзменяемыйРеквизит, НовоеПредставление, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	// Обработчик не должен вызываться из неподготовленных форм, поэтому вызовем исключение,
	// если вызывающая форма не соответствует требованиям.
	БанкИКассаФормыКлиентСервер.ПроверитьВозможностьОтраженияДоходов(Форма);
	
	ВариантыОтраженияДоходов = БанкИКассаФормыКлиентСервер.ВариантыОтраженияДоходов(Форма);
	
	Если ЗначениеЗаполнено(НовоеПредставление) Тогда
		
		// Пользователь выбрал представление - обновим значение связанного реквизита.
		ИзменяемыйРеквизит = БанкИКассаФормыКлиентСервер.ВариантОтраженияДоходовЗначение(
			НовоеПредставление,
			ВариантыОтраженияДоходов);
		
	Иначе
		
		// Если новое представление пользователем не выбрано - заполним отражение дохода значением по умолчанию.
		ИзменяемыйРеквизит = ЗначениеПоУмолчанию;
		
		НовоеПредставление = БанкИКассаФормыКлиентСервер.ВариантОтраженияДоходовПредставление(
			ИзменяемыйРеквизит,
			ВариантыОтраженияДоходов);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти