#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПеренестиНазначениеПлатежаПриПереходеНаНовуюВерсию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бит_ПланируемоеПоступлениеДенежныхСредств.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.бит_ПланируемоеПоступлениеДенежныхСредств КАК бит_ПланируемоеПоступлениеДенежныхСредств";
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ТекущийОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ТекущийОбъект.НазначениеПлатежа	   = ТекущийОбъект.УдалитьНазначениеПлатежа;   
		ТекущийОбъект.НазначениеПлатежаУпр = ТекущийОбъект.УдалитьНазначениеПлатежаУпр;   
		
		Для Каждого СтрокаТаблицы Из ТекущийОбъект.Распределение Цикл
			
			ТекущийОбъект.НазначениеПлатежа	   = ТекущийОбъект.УдалитьНазначениеПлатежа;   
			ТекущийОбъект.НазначениеПлатежаУпр = ТекущийОбъект.УдалитьНазначениеПлатежаУпр;   			
			
		КонецЦикла; 
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ТекущийОбъект);
		
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#КонецЕсли
