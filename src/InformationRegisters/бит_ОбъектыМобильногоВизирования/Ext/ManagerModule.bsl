#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Формирует список полей для подстановки в шаблоны.
// Значение - форматная строка в формате C#, потому что форматирование происходит на стороне мобильного приложения.
// Представление - имя поля. 
// 
Функция СформироватьСписокПолей() Экспорт
	
	СписокПолей = Новый СписокЗначений;
	СписокПолей.Добавить(""           , "Company");
	СписокПолей.Добавить(""           , "Department");
	СписокПолей.Добавить(""           , "TurnoverItem");
	СписокПолей.Добавить(""           , "Project");
	СписокПолей.Добавить(""           , "Partner");
	СписокПолей.Добавить(""           , "Contract");
	СписокПолей.Добавить("dd.MM.yyy"  , "PaymentDate");
	СписокПолей.Добавить("0.00"       , "Amount");
	СписокПолей.Добавить(""           , "Currency");
	СписокПолей.Добавить(""           , "ManagerialPurpose");
	СписокПолей.Добавить(""           , "OverBudget");
	СписокПолей.Добавить(""           , "ResponsiblePerson");
	СписокПолей.Добавить(""           , "Scenario");
	СписокПолей.Добавить(""           , "Comment");
	СписокПолей.Добавить(""           , "Number");
	СписокПолей.Добавить("dd.MM.yyyy" , "Date");
	
	Возврат СписокПолей;
	
КонецФункции // СформироватьСписокПолей()	

#КонецОбласти

#КонецЕсли
