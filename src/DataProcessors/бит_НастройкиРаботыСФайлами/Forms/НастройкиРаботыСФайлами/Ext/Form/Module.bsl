﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	ПанельНастроекЗаполнитьРежимРаботы(РежимРаботы);
	
	МаксимальныйРазмерФайла              = РаботаСФайлами.МаксимальныйРазмерФайлаОбщий() / (1024*1024);
	МаксимальныйРазмерФайлаОбластиДанных = РаботаСФайлами.МаксимальныйРазмерФайла() / (1024*1024);
	Если РежимРаботы.МодельСервиса Тогда
		Элементы.МаксимальныйРазмерФайла.МаксимальноеЗначение = МаксимальныйРазмерФайла;
	КонецЕсли;
	
	// Настройки видимости при запуске
	Элементы.ГруппаИзвлекатьТекстыФайловНаСервере.Видимость   = РежимРаботы.КлиентСерверный;
	Элементы.ГруппаРедактироватьРегламентноеЗадание.Видимость = РежимРаботы.ЛокальныйКлиентСерверный;
	Элементы.ГруппаОбработкаАвтоматическоеИзвлечениеТекстов.Видимость = РежимРаботы.Локальный;
	Элементы.ГруппаОбработкаАвтоматическоеИзвлечениеТекстовДляВсехОбластейДанных.Видимость = РежимРаботы.МодельСервиса;
	
	Если РежимРаботы.ЭтоАдминистраторСистемы Тогда
		Элементы.ОбщиеПараметрыДляВсехОбластейДанных.Видимость = РежимРаботы.МодельСервиса;
	КонецЕсли;
	
	// Обновление состояния элементов
	УстановитьДоступность();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХранитьФайлыВТомахНаДискеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗапрещатьЗагрузкуФайловПоРасширениюПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокЗапрещенныхРасширенийОбластиДанныхПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаОбластиДанныхПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийФайловOpenDocumentОбластиДанныхПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийТекстовыхФайловПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЭлектронныеЦифровыеПодписиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИзвлекатьТекстыФайловНаСервереПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Общие параметры для всех областей данных

&НаКлиенте
Процедура МаксимальныйРазмерФайлаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокЗапрещенныхРасширенийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийФайловOpenDocumentПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СправочникТомаХраненияФайлов(Команда)
	ОткрытьФорму("Справочник.ТомаХраненияФайлов.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбщаяФормаНастройкиЭЦП(Команда)
	ОткрытьФорму("ОбщаяФорма.НастройкиЭлектроннойПодписиИШифрования", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьРегламентноеЗадание(Команда)
	ИмяОткрываемойФормы = "Обработка.РегламентныеИФоновыеЗадания.Форма";
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Действие", "Изменить");
	ПараметрыФормы.Вставить("Идентификатор", Строка(ИдентификаторПредопределенногоРегламентногоЗадания("ИзвлечениеТекста")));
	
	ВладелецФормы = Неопределено;
	УникальностьФормы = Ложь;
	ОкноФормы = Неопределено;
	
	ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыФормы, ВладелецФормы, УникальностьФормы, ОкноФормы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определение режима работы для панелей настроек.
// 
// В панелях настроек включены 4 интерфейса:
//  - Для администратора сервиса в области данных абонента (АС).
//  - Для администратора абонента (АА).
//  - Для администратора локального решения в клиент-серверном режиме (ЛКС).
//  - Для администратора локального решения в файловом режиме (ЛФ).
// 
// Интерфейсы АС и АА разрезаются при помощи скрытия групп и элементов формы
//  для всех ролей, кроме роли "АдминистраторСистемы".
// 
// Администратор сервиса, выполнивший вход в область данных,
//  должен видеть те же настройки что и администратор абонента
//  вместе с настройками сервиса (неразделенными).
//
&НаСервере
Процедура ПанельНастроекЗаполнитьРежимРаботы(РежимРаботы) Экспорт
	РежимРаботы = Новый Структура;
	
	// Права пользователя
	РежимРаботы.Вставить("ЭтоАдминистраторПрограммы", Пользователи.ЭтоПолноправныйПользователь()); // АА, АС, ЛКС, ЛФ
	РежимРаботы.Вставить("ЭтоАдминистраторСистемы",   Пользователи.ЭтоПолноправныйПользователь(, Истина)); // АС, ЛКС, ЛФ
	
	// Общие настройки
	РежимРаботы.Вставить("МодельСервиса", Ложь);   // АС, АА
	РежимРаботы.Вставить("Локальный", Ложь);       // ЛКС, ЛФ
	РежимРаботы.Вставить("Файловый", Ложь);        // АС, АА, ЛФ
	РежимРаботы.Вставить("КлиентСерверный", Ложь); // АС, АА, ЛКС
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		РежимРаботы.МодельСервиса = Истина;
	Иначе
		РежимРаботы.Локальный = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		РежимРаботы.Файловый = Истина;
	Иначе
		РежимРаботы.КлиентСерверный = Истина;
	КонецЕсли;
	
	// Точные настройки
	РежимРаботы.Вставить("АдминистраторСервиса",
		РежимРаботы.МодельСервиса И РежимРаботы.ЭтоАдминистраторСистемы
	); // АС
	РежимРаботы.Вставить("АдминистраторАбонента",
		РежимРаботы.МодельСервиса И НЕ РежимРаботы.ЭтоАдминистраторСистемы И РежимРаботы.ЭтоАдминистраторПрограммы
	); // АА
	РежимРаботы.Вставить("ЛокальныйФайловый",
		РежимРаботы.Локальный И РежимРаботы.Файловый
	); // ЛФ
	РежимРаботы.Вставить("ЛокальныйКлиентСерверный",
		РежимРаботы.Локальный И РежимРаботы.КлиентСерверный
	); // ЛКС
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		// НастройкиПрограммыКлиент.ПодключитьОбработчикОбновленияИнтерфейса();
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Процедура ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИдентификаторПредопределенногоРегламентногоЗадания(ИмяПредопределенного)
	МетаданныеПредопределенного = Метаданные.РегламентныеЗадания.Найти(ИмяПредопределенного);
	Если МетаданныеПредопределенного = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Регламентное задание ""%1"" не найдено в метаданных.'"),
			ИмяПредопределенного
		);
	КонецЕсли;
	
	РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(МетаданныеПредопределенного);
	Если РегламентноеЗадание = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Регламентное задание ""%1"" не найдено.'"),
			ИмяПредопределенного
		);
	КонецЕсли;
	
	Возврат РегламентноеЗадание.УникальныйИдентификатор;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "МаксимальныйРазмерФайла" Тогда
			НаборКонстант.МаксимальныйРазмерФайла = МаксимальныйРазмерФайла * (1024*1024);
			КонстантаИмя = "МаксимальныйРазмерФайла";
		ИначеЕсли РеквизитПутьКДанным = "МаксимальныйРазмерФайлаОбластиДанных" Тогда
			Если РежимРаботы.Локальный Тогда
				НаборКонстант.МаксимальныйРазмерФайла = МаксимальныйРазмерФайлаОбластиДанных * (1024*1024);
				КонстантаИмя = "МаксимальныйРазмерФайла";
			Иначе
				НаборКонстант.МаксимальныйРазмерФайлаОбластиДанных = МаксимальныйРазмерФайлаОбластиДанных * (1024*1024);
				КонстантаИмя = "МаксимальныйРазмерФайлаОбластиДанных";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ХранитьФайлыВТомахНаДиске" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.СправочникТомаХраненияФайлов.Доступность = НаборКонстант.ХранитьФайлыВТомахНаДиске;
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ЗапрещатьЗагрузкуФайловПоРасширению" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.СписокЗапрещенныхРасширенийОбластиДанных.Доступность = НаборКонстант.ЗапрещатьЗагрузкуФайловПоРасширению;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЭлектронныеЦифровыеПодписи" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ОбщаяФормаНастройкиЭЦП.Доступность = НаборКонстант.ИспользоватьЭлектронныеПодписи;
	КонецЕсли;
	
	Если РежимРаботы.ЭтоАдминистраторСистемы Тогда
		
		Если РеквизитПутьКДанным = "НаборКонстант.ИзвлекатьТекстыФайловНаСервере" ИЛИ РеквизитПутьКДанным = "" Тогда
			Элементы.РедактироватьРегламентноеЗадание.Доступность                              = НаборКонстант.ИзвлекатьТекстыФайловНаСервере;
			Элементы.ОбработкаАвтоматическоеИзвлечениеТекстов.Доступность                      = НЕ НаборКонстант.ИзвлекатьТекстыФайловНаСервере;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

