
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Задание = РегламентноеЗадание();
	Элементы.КомандаРасписание.Заголовок = Задание.Расписание;
	
	БотДляОповещений 		= бит_ТелеграмПовтИсп.ГлавныйБот();
	ОповещенияЗапущены 		= Задание.Использование;
	ЕстьАдминистраторыБота 	= ПроверитьНаличиеАдминистраторовБота(БотДляОповещений);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеЭлементамиФормыКлиент();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БотДляОповещенийПриИзменении(Элемент)
	ЕстьАдминистраторыБота 	= ПроверитьНаличиеАдминистраторовБота(БотДляОповещений);
	УправлениеЭлементамиФормыКлиент();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияАдминистраторыНеНайденыНажатие(Элемент)
	
	СтрПараметров = Новый Структура("БотТелеграм", БотДляОповещений);
	ОткрытьФорму("РегистрСведений.бит_ЧатыДляСлужебныхОповещенийТелеграм.ФормаЗаписи",СтрПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗапуститьВзаимодействие(Команда)

	ОповещенияЗапущены = НЕ ОповещенияЗапущены;
	
	ПериодическаяОтправкаЗапросовТелеграм(ОповещенияЗапущены, БотДляОповещений);
	УправлениеЭлементамиФормыКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСообщениеЧату(Команда)
	
	СтрПараметров = Новый Структура("БотТелеграм", БотДляОповещений);
	ОткрытьФорму("ОбщаяФорма.бит_ФормаОтправкиСообщенияВТелеграм",СтрПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписание(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьРасписание", ЭтотОбъект);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ПолучитьРасписание());
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьТокенБота(Команда)
	
	ПроверитьТокен(БотДляОповещений);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеЭлементамиФормыКлиент()

	Элементы.ДекорацияИнфоСтарт.Видимость 	= ОповещенияЗапущены;
	Элементы.ДекорацияИнфоСтоп.Видимость 	= НЕ ОповещенияЗапущены;
	Элементы.Запустить.Пометка 				= ОповещенияЗапущены;
	ЭтотОбъект.ТолькоПросмотр 				= ОповещенияЗапущены;
	Элементы.Запустить.Заголовок 			= ?(ОповещенияЗапущены,
											НСтр("ru = 'Остановить взаимодействие'"),
											НСтр("ru = 'Запустить взаимодействие'"));
											
	Элементы.ДекорацияАдминистраторыНеНайдены.Видимость = НЕ ЕстьАдминистраторыБота;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПериодическаяОтправкаЗапросовТелеграм(ОповещенияЗапущены, БотДляОповещений)

	Константы.бит_БотДляОповещенийТелеграм.Установить(БотДляОповещений);
	ОбновитьПовторноИспользуемыеЗначения();
	
	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.бит_ОповещенияТелеграм);
	
	Задание.Использование = ОповещенияЗапущены;
	Задание.Записать();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьНаличиеАдминистраторовБота(БотДляОповещений)

	ЕстьАдминистраторы = бит_ТелеграмСервер.ПроверитьНаличиеАдминистраторовБота(БотДляОповещений);

	Возврат ЕстьАдминистраторы;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьРасписание()

	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.бит_ОповещенияТелеграм);
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Задание.Расписание;
	
КонецФункции // ПолучитьРасписание()

&НаСервереБезКонтекста
Процедура УстановитьРасписаниеНаСервере(РасписаниеЗадания)

	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.бит_ОповещенияТелеграм);

	Задание.Расписание = РасписаниеЗадания;
	Задание.Записать();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры // ПолучитьРасписание()

// Процедура окончание выбора расписания задания. 
//
// Параметры:
//  РезультатВыбора         - Структура.
//  ДополнительныеПараметры - Структура.
//
&НаКлиенте 
Процедура УстановитьРасписание(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.КомандаРасписание.Заголовок = РасписаниеЗадания;
	УстановитьРасписаниеНаСервере(РасписаниеЗадания);
	
КонецПроцедуры // УстановитьРасписание()

// Процедура выполняет проверку токена.
//
&НаСервереБезКонтекста
Процедура ПроверитьТокен(БотДляОповещений)
	
	ТестоваяПроверка = Справочники.бит_БотыTelegram.ПроверитьТокен(БотДляОповещений.Токен);
	
	Если ТестоваяПроверка.Существует Тогда
		
		ТекстСообщения =  НСтр("ru = 'Проверка выполнена успешно.'");
	Иначе	
		
		ТекстСообщения =  НСтр("ru = 'Ошибка выполнения проверки. %1.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", ТестоваяПроверка.Сообщение);
		
	КонецЕсли; 
	
	бит_ТелеграмКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры // ПроверитьТокен()

&НаСервере
Функция РегламентноеЗадание()

	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.бит_ОповещенияТелеграм);
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Задание;
	
КонецФункции

#КонецОбласти
