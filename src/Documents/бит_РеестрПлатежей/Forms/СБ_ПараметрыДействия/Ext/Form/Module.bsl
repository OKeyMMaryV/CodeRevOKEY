////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("Организация", Организация);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаСервереБезКонтекста
Функция ПолучитьВалютуРегламентированногоУчета()

	   Возврат Константы.ВалютаРегламентированногоУчета.Получить();

КонецФункции //ПолучитьВалютуРегламентированногоУчета()
 

&НаКлиенте
Процедура БанковскийСчетОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	Отбор = Новый Структура;
	Если НЕ Организация.Пустая() Тогда
		Отбор.Вставить("Владелец"       	  , Организация);
	КонецЕсли;	
	Отбор.Вставить("ВалютаДенежныхСредств", ПолучитьВалютуРегламентированногоУчета());
	Если ЗначениеЗаполнено(БанковскийСчетОрганизация) Тогда
		СтруктураПараметров.Вставить("ТекущийЭлемент" , БанковскийСчетОрганизация);
	КонецЕсли;	
	СтруктураПараметров.Вставить("Отбор", Отбор);
	СтруктураПараметров.Вставить("ЗакрыватьПриВыборе", Истина);
	
	ФормаСчета = ПолучитьФорму("Справочник.БанковскиеСчета.ФормаВыбора",СтруктураПараметров,Элемент);
	Если НЕ ФормаСчета.Открыта() Тогда
    	ФормаСчета.Открыть();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	ЕстьОшибка = Ложь;
	
	Если БанковскийСчетОрганизация.Пустая() Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Укажите банковский счет";
		Сообщение.Поле = "БанковскийСчетОрганизация";
		Сообщение.Сообщить(); 
		
		ЕстьОшибка = Истина;
		
	КонецЕсли; 
	
	Если Сумма = 0 Тогда
	
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Укажите сумму распределения";
		Сообщение.Поле = "Сумма";
		Сообщение.Сообщить(); 
		
		ЕстьОшибка = Истина;
		
	КонецЕсли; 
	
	Если ЕстьОшибка Тогда
		Возврат;	               	
	КонецЕсли; 
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("БанковскийСчетОрганизация", БанковскийСчетОрганизация);
	СтруктураВозврата.Вставить("Сумма",						Сумма);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОПОВЕЩЕНИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


